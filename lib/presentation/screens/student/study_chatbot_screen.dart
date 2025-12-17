import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class StudyChatbotScreen extends StatefulWidget {
  const StudyChatbotScreen({super.key});

  @override
  State<StudyChatbotScreen> createState() => _StudyChatbotScreenState();
}

class _StudyChatbotScreenState extends State<StudyChatbotScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  bool _showGuidelines = true;
  bool _showQuickActions = true;

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _messages.add(ChatMessage(
      text:
          '👋 Hi! I\'m your study assistant. How can I help you today?',
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _showQuickActions = false;
    });

    _messageController.clear();
    _scrollToBottom();

    // Check for blocked queries
    if (_isExamRelatedQuery(text)) {
      _showBlockedResponse();
    } else {
      _showTypingIndicator();
      _generateMockResponse(text);
    }
  }

  bool _isExamRelatedQuery(String text) {
    final blockedKeywords = [
      'answer',
      'exam',
      'test',
      'question',
      'solution',
      'solve this',
      'cia',
      'semester exam'
    ];
    final lowerText = text.toLowerCase();
    return blockedKeywords.any((keyword) => lowerText.contains(keyword));
  }

  void _showTypingIndicator() {
    setState(() {
      _isTyping = true;
    });
  }

  void _hideTypingIndicator() {
    setState(() {
      _isTyping = false;
    });
  }

  void _showBlockedResponse() {
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            text:
                '⚠️ I cannot provide exam answers. However, I can explain the concept! What topic would you like to understand better?',
            isUser: false,
            timestamp: DateTime.now(),
            isWarning: true,
          ));
        });
        _scrollToBottom();
      }
    });
  }

  void _generateMockResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();
    String response = '';

    if (lowerMessage.contains('binary tree') ||
        lowerMessage.contains('bst') ||
        lowerMessage.contains('binary search tree')) {
      response =
          '📚 A binary tree is a hierarchical data structure where each node has at most two children, called left and right child. A binary search tree (BST) is a special type where:\n\n• Left child < Parent node\n• Right child > Parent node\n\nThis property makes searching very efficient - O(log n) time complexity in balanced trees!';
    } else if (lowerMessage.contains('linked list')) {
      response =
          '📚 A linked list is a linear data structure where elements are stored in nodes. Each node contains:\n\n• Data field (stores the value)\n• Pointer field (stores reference to next node)\n\nTypes: Singly, Doubly, and Circular linked lists.\n\nAdvantages: Dynamic size, easy insertion/deletion\nDisadvantages: No random access, extra memory for pointers';
    } else if (lowerMessage.contains('array')) {
      response =
          '📚 An array is a collection of elements stored in contiguous memory locations. Key features:\n\n• Fixed size (in most languages)\n• Same data type\n• Random access - O(1)\n• Index-based access\n\nPerfect for when you know the size beforehand and need fast access!';
    } else if (lowerMessage.contains('hello') ||
        lowerMessage.contains('hi')) {
      response = '👋 Hello! I\'m here to help you learn. What subject or topic would you like to explore today?';
    } else if (lowerMessage.contains('quiz') ||
        lowerMessage.contains('practice')) {
      response =
          '📝 Great! Let me give you some practice questions:\n\n1. What is the time complexity of binary search?\n2. Explain the difference between stack and queue\n3. What are the properties of a binary search tree?\n\nTry answering these, and I can explain any concept you\'re unsure about!';
    } else {
      response =
          '🤔 That\'s an interesting question! Here\'s what I can explain:\n\nI can help you understand concepts related to:\n• Data Structures\n• Algorithms\n• Programming basics\n• Database concepts\n• Operating Systems\n\nCould you be more specific about what you\'d like to learn?';
    }

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _hideTypingIndicator();
        setState(() {
          _messages.add(ChatMessage(
            text: response,
            isUser: false,
            timestamp: DateTime.now(),
          ));
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearConversation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Clear Conversation?',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'This will delete all messages in the current conversation.',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _messages.clear();
                _messages.add(ChatMessage(
                  text:
                      '👋 Hi! I\'m your study assistant. How can I help you today?',
                  isUser: false,
                  timestamp: DateTime.now(),
                ));
                _showQuickActions = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90E2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Clear', style: GoogleFonts.inter(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Guidelines Banner
          if (_showGuidelines) _buildGuidelinesBanner(),

          // Chat Messages Area
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length +
                  (_isTyping ? 1 : 0) +
                  (_showQuickActions ? 1 : 0),
              itemBuilder: (context, index) {
                if (_showQuickActions && index == _messages.length) {
                  return _buildQuickActions();
                }

                if (_isTyping &&
                    index == _messages.length + (_showQuickActions ? 1 : 0)) {
                  return _buildTypingIndicator();
                }

                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          // Input Area
          _buildInputArea(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF212121)),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Study Chatbot',
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF212121),
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Color(0xFF212121)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onSelected: (value) {
            if (value == 'clear') {
              _clearConversation();
            } else if (value == 'guidelines') {
              setState(() {
                _showGuidelines = true;
              });
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'clear',
              child: Row(
                children: [
                  const Icon(Icons.delete_outline, size: 20, color: Color(0xFF757575)),
                  const SizedBox(width: 12),
                  Text('Clear conversation', style: GoogleFonts.inter()),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'guidelines',
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 20, color: Color(0xFF757575)),
                  const SizedBox(width: 12),
                  Text('Show guidelines', style: GoogleFonts.inter()),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'report',
              child: Row(
                children: [
                  const Icon(Icons.report_outlined, size: 20, color: Color(0xFF757575)),
                  const SizedBox(width: 12),
                  Text('Report issue', style: GoogleFonts.inter()),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGuidelinesBanner() {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4A90E2).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF4A90E2), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Ask me anything about your subjects! I can help with concepts, not exam answers.',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF1565C0),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18, color: Color(0xFF1565C0)),
            onPressed: () {
              setState(() {
                _showGuidelines = false;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF4A90E2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 18),
            ),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onLongPress: () => _showCopyOption(message.text),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: message.isWarning
                          ? const Color(0xFFFFF8E1)
                          : message.isUser
                              ? const Color(0xFFE3F2FD)
                              : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(message.isUser ? 16 : 4),
                        topRight: Radius.circular(message.isUser ? 4 : 16),
                        bottomLeft: const Radius.circular(16),
                        bottomRight: const Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      message.text,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF212121),
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(message.timestamp),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(right: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF4A90E2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.smart_toy, color: Colors.white, size: 18),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(1),
                const SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        final delay = index * 0.15;
        final animValue = (value + delay) % 1.0;
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Color.lerp(
              const Color(0xFFBDBDBD),
              const Color(0xFF757575),
              (animValue * 2).clamp(0.0, 1.0),
            ),
            shape: BoxShape.circle,
          ),
        );
      },
      onEnd: () {
        if (mounted && _isTyping) {
          setState(() {});
        }
      },
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _buildQuickActionChip('Explain concepts'),
          _buildQuickActionChip('Practice quiz'),
          _buildQuickActionChip('Summarize topic'),
        ],
      ),
    );
  }

  Widget _buildQuickActionChip(String label) {
    return GestureDetector(
      onTap: () => _sendMessage(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE0E0E0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF4A90E2),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: const Color(0xFFE0E0E0), width: 1),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  style: GoogleFonts.inter(fontSize: 14),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: _sendMessage,
                  decoration: InputDecoration(
                    hintText: 'Ask something...',
                    hintStyle: GoogleFonts.inter(
                      color: const Color(0xFF9E9E9E),
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _sendMessage(_messageController.text),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _messageController.text.isEmpty
                      ? const Color(0xFFBDBDBD)
                      : const Color(0xFF4A90E2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCopyOption(String text) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Message Options', style: GoogleFonts.inter()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy, color: Color(0xFF4A90E2)),
              title: Text('Copy text', style: GoogleFonts.inter()),
              onTap: () {
                Clipboard.setData(ClipboardData(text: text));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Copied to clipboard',
                        style: GoogleFonts.inter()),
                    duration: const Duration(seconds: 2),
                    backgroundColor: const Color(0xFF4CAF50),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour;
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final period = timestamp.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isWarning;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isWarning = false,
  });
}

