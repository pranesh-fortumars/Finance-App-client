import 'package:flutter/material.dart';
import '../models/notification.dart' as app_notification;
import '../models/notification_config.dart';
import '../services/storage_service.dart';
import '../widgets/common/card_widget.dart';
import '../widgets/common/button_widget.dart';
import '../utils/calculations.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final StorageService _storageService = StorageService.instance;

  List<app_notification.Notification> _notifications = [];
  bool _isLoading = true;
  app_notification.NotificationType? _selectedType;
  bool _showReadOnly = false;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    try {
      final notifications = await _storageService.getNotifications();
      setState(() {
        _notifications = notifications;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<app_notification.Notification> get _filteredNotifications {
    return _notifications.where((notification) {
      bool matchesType =
          _selectedType == null || notification.type == _selectedType;
      bool matchesReadStatus = _showReadOnly || !notification.read;
      return matchesType && matchesReadStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      body: Column(
        children: [
          // Header with Filters
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Notifications',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.grey[100] : Colors.grey[900],
                      ),
                    ),
                    const Spacer(),
                    ButtonWidget(
                      text: 'Settings',
                      icon: Icons.settings,
                      size: ButtonSize.small,
                      onPressed: _showNotificationSettings,
                    ),
                    const SizedBox(width: 8),
                    ButtonWidget(
                      text: 'Mark All Read',
                      icon: Icons.done_all,
                      size: ButtonSize.small,
                      onPressed: _markAllAsRead,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child:
                          DropdownButtonFormField<
                            app_notification.NotificationType?
                          >(
                            initialValue: _selectedType,
                            decoration: const InputDecoration(
                              labelText: 'Filter by Type',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            items: [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('All Types'),
                              ),
                              ...app_notification.NotificationType.values.map((
                                type,
                              ) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: Text(
                                    type
                                        .toString()
                                        .split('.')
                                        .last
                                        .toUpperCase(),
                                  ),
                                );
                              }),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedType = value;
                              });
                            },
                          ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Row(
                        children: [
                          Checkbox(
                            value: _showReadOnly,
                            onChanged: (value) {
                              setState(() {
                                _showReadOnly = value ?? false;
                              });
                            },
                          ),
                          const Text('Show read only'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Notifications List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredNotifications.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = _filteredNotifications[index];
                      return _buildNotificationCard(notification);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: isDark ? Colors.grey[600] : Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications found',
            style: theme.textTheme.titleMedium?.copyWith(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? Colors.grey[500] : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(app_notification.Notification notification) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CardWidget(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _markAsRead(notification),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: notification.read
                ? null
                : Border.all(
                    color: Colors.blue.withValues(alpha: 0.3),
                    width: 2,
                  ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getNotificationTypeColor(
                    notification.type,
                  ).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  _getNotificationTypeIcon(notification.type),
                  color: _getNotificationTypeColor(notification.type),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: notification.read
                                  ? FontWeight.normal
                                  : FontWeight.w600,
                              color: isDark
                                  ? Colors.grey[100]
                                  : Colors.grey[900],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!notification.read)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 14,
                          color: isDark ? Colors.grey[500] : Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          Calculations.formatDate(notification.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark ? Colors.grey[500] : Colors.grey[500],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getNotificationTypeColor(
                              notification.type,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            notification.type
                                .toString()
                                .split('.')
                                .last
                                .toUpperCase(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: _getNotificationTypeColor(
                                notification.type,
                              ),
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'mark_read',
                    child: Row(
                      children: [
                        Icon(
                          notification.read
                              ? Icons.mark_email_read
                              : Icons.mark_email_unread,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          notification.read ? 'Mark as unread' : 'Mark as read',
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 16, color: Colors.red),
                        const SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  switch (value) {
                    case 'mark_read':
                      _markAsRead(notification);
                      break;
                    case 'delete':
                      _deleteNotification(notification);
                      break;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getNotificationTypeColor(app_notification.NotificationType type) {
    switch (type) {
      case app_notification.NotificationType.payment:
        return Colors.green;
      case app_notification.NotificationType.reminder:
        return Colors.orange;
      case app_notification.NotificationType.system:
        return Colors.blue;
      case app_notification.NotificationType.alert:
        return Colors.red;
      case app_notification.NotificationType.info:
        return Colors.blue;
    }
  }

  IconData _getNotificationTypeIcon(app_notification.NotificationType type) {
    switch (type) {
      case app_notification.NotificationType.payment:
        return Icons.payment;
      case app_notification.NotificationType.reminder:
        return Icons.schedule;
      case app_notification.NotificationType.system:
        return Icons.settings;
      case app_notification.NotificationType.alert:
        return Icons.warning;
      case app_notification.NotificationType.info:
        return Icons.info;
    }
  }

  Future<void> _markAsRead(app_notification.Notification notification) async {
    if (!notification.read) {
      await _storageService.markNotificationAsRead(notification.id);
      _loadNotifications();
    }
  }

  Future<void> _markAllAsRead() async {
    for (final notification in _notifications.where((n) => !n.read)) {
      await _storageService.markNotificationAsRead(notification.id);
    }
    _loadNotifications();
  }

  Future<void> _deleteNotification(
    app_notification.Notification notification,
  ) async {
    await _storageService.deleteNotification(notification.id);
    _loadNotifications();
  }

  void _showNotificationSettings() {
    showDialog(
      context: context,
      builder: (context) => _NotificationSettingsDialog(),
    );
  }
}

class _NotificationSettingsDialog extends StatefulWidget {
  @override
  State<_NotificationSettingsDialog> createState() =>
      _NotificationSettingsDialogState();
}

class _NotificationSettingsDialogState
    extends State<_NotificationSettingsDialog> {
  final StorageService _storageService = StorageService.instance;
  late NotificationConfig _config;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final config = await _storageService.getNotificationConfig();
    setState(() {
      _config = config;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(24),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notification Settings',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.grey[100] : Colors.grey[900],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SwitchListTile(
                    title: const Text('Email Notifications'),
                    subtitle: const Text('Receive notifications via email'),
                    value: _config.emailEnabled,
                    onChanged: (value) {
                      setState(() {
                        _config = _config.copyWith(emailEnabled: value);
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('WhatsApp Notifications'),
                    subtitle: const Text('Receive notifications via WhatsApp'),
                    value: _config.whatsappEnabled,
                    onChanged: (value) {
                      setState(() {
                        _config = _config.copyWith(whatsappEnabled: value);
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Reminder Settings',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey[200] : Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Reminder Days: ${_config.reminderDays.join(', ')}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Escalation Days: ${_config.escalationDays.join(', ')}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Report Schedule: ${_config.reportSchedule}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 12),
                      ButtonWidget(text: 'Save', onPressed: _saveConfig),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _saveConfig() async {
    await _storageService.saveNotificationConfig(_config);
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification settings saved!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
