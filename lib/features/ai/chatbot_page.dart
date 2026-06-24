import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/ai_service.dart';
import '../../services/firestore_service.dart';
import '../../models/chat_message_model.dart';
import '../../utils/app_colors.dart';

class ChatbotPage extends StatefulWidget {
  final String? conversationId;
  const ChatbotPage({super.key, this.conversationId});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  
  String? currentConversationId;
  Stream<List<ChatMessageModel>>? _messagesStream;
  bool isLoading = false;

  double salary = 0;
  double savingsGoal = 0;
  double totalExpenses = 0;
  String recentTransactions = '';

  final firestoreService = FirestoreService();
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> loadUserData() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    final data = doc.data();

    if (data != null) {
      salary = ((data['salary'] ?? 0) as num).toDouble();
      savingsGoal = ((data['savingsGoal'] ?? 0) as num).toDouble();
    }

    totalExpenses = await firestoreService.getMonthlyTotalExpenses(userId);
    final recentExpenses = await firestoreService.getRecentExpenses(userId);

    recentTransactions = recentExpenses.map((expense) {
      final data = expense.data();
      return '${data['title']} - ${data['category']} - ${data['amount']} DT';
    }).join('\n');
  }

  @override
  void initState() {
    super.initState();
    currentConversationId = widget.conversationId;
    loadUserData();

    if (currentConversationId != null) {
      _messagesStream = firestoreService.getConversationMessages(userId, currentConversationId!);
    }
  }

  Future<void> _sendMessage() async {
    final userMessage = messageController.text.trim();
    if (userMessage.isEmpty) return;

    messageController.clear();
    
    setState(() {
      isLoading = true;
    });

    try {
      final isNewChat = currentConversationId == null;
      if (isNewChat) {
        // Generate a new Firestore document reference to obtain a unique ID
        final docRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('conversations')
            .doc();
        
        currentConversationId = docRef.id;

        // Set conversation title to the first message text
        final title = userMessage.length > 30 
            ? '${userMessage.substring(0, 30)}...' 
            : userMessage;

        await firestoreService.createConversation(userId, currentConversationId!, title);

        // Bind the stream to this new conversation so UI updates reactively
        setState(() {
          _messagesStream = firestoreService.getConversationMessages(userId, currentConversationId!);
        });
      }

      // Save user message to Firestore
      final userMessageModel = ChatMessageModel(
        sender: 'user',
        text: userMessage,
        timestamp: DateTime.now(),
      );

      await firestoreService.saveChatMessage(userId, currentConversationId!, userMessageModel);

      // Construct history context for Groq from the stream snapshot
      // If it's a new chat, the history is just empty.
      String conversationHistory = '';
      if (!isNewChat) {
        // We can load the history once to pass to the API
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('conversations')
            .doc(currentConversationId)
            .collection('messages')
            .orderBy('timestamp', descending: false)
            .get();

        conversationHistory = snapshot.docs
            .map((doc) => '${doc.data()['sender']}: ${doc.data()['text']}')
            .join('\n');
      }

      // Call Groq API
      final reply = await AIService().sendMessage(
        conversationHistory: conversationHistory,
        userMessage: userMessage,
        salary: salary,
        expenses: totalExpenses,
        savingsGoal: savingsGoal,
        recentTransactions: recentTransactions,
      );

      // Save bot reply to Firestore
      final botMessageModel = ChatMessageModel(
        sender: 'bot',
        text: reply,
        timestamp: DateTime.now(),
      );

      await firestoreService.saveChatMessage(userId, currentConversationId!, botMessageModel);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Flousi AI 🤖', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: _messagesStream == null
                ? _buildEmptyChatState()
                : StreamBuilder<List<ChatMessageModel>>(
                    stream: _messagesStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.lavender),
                          ),
                        );
                      }

                      final dbMessages = snapshot.data ?? [];
                      
                      // Combine DB messages and virtual "Thinking..." message
                      final displayMessages = List<ChatMessageModel>.from(dbMessages);
                      if (isLoading) {
                        displayMessages.add(ChatMessageModel(
                          sender: 'bot',
                          text: 'Thinking...',
                          timestamp: DateTime.now(),
                        ));
                      }

                      if (displayMessages.isEmpty) {
                        return _buildEmptyChatState();
                      }

                      // Reverse messages so index 0 is visual bottom (latest message)
                      final reversedMessages = displayMessages.reversed.toList();

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        reverse: true,
                        itemCount: reversedMessages.length,
                        itemBuilder: (context, index) {
                          final message = reversedMessages[index];
                          final isUser = message.sender == 'user';

                          if (message.text == 'Thinking...') {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.grey.shade200),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Flousi is thinking...',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return Align(
                            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.75,
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: isUser ? AppColors.lavender : Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(16),
                                  topRight: const Radius.circular(16),
                                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                                  bottomRight: Radius.circular(isUser ? 4 : 16),
                                ),
                                boxShadow: isUser
                                    ? []
                                    : [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.02),
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                              ),
                              child: Text(
                                message.text,
                                style: TextStyle(
                                  color: isUser ? Colors.deepPurple.shade900 : Colors.black87,
                                  fontSize: 15,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
          
          // Chat input bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: messageController,
                      minLines: 1,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Ask Flousi something...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.lavender,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.black87),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChatState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.sage,
                shape: BoxShape.circle,
              ),
              child: const Text('💡', style: TextStyle(fontSize: 36)),
            ),
            const SizedBox(height: 24),
            const Text(
              'Start a New Conversation',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Ask me questions about your monthly budget, recent transactions, tips to reach your savings goals, or general personal finance questions.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}