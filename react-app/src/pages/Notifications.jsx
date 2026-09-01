import React, { useState } from 'react';
import { useDataContext } from '../context/DataContext';
import { FirebaseService } from '../services/firebase';
import Card from '../components/common/Card';
import { Bell, Check, Trash2 } from 'lucide-react';
import './Pages.css';

const Notifications = () => {
  const { notifications, refreshData, isLoading } = useDataContext();
  
  const handleMarkAsRead = async (notification) => {
    try {
      await FirebaseService.saveNotification({ ...notification, read: true });
      await refreshData();
    } catch (error) {
      console.error("Error marking read", error);
    }
  };

  const handleDelete = async (notification) => {
    // Note: Assuming a deleteNotification function exists in FirebaseService, 
    // or we can simulate it by marking it as deleted if we had a flag.
    alert("Delete not yet fully wired to Firebase!");
  };

  if (isLoading) return <div className="screen-center">Loading Notifications...</div>;

  return (
    <div className="page-container">
      <div className="page-header">
        <h2 style={{ margin: 0, display: 'flex', alignItems: 'center', gap: '8px' }}>
          <Bell size={24} color="#f59e0b" /> Notifications
        </h2>
      </div>

      <div className="list-container">
        {notifications.length === 0 ? (
          <div className="center-message">
            <Bell size={48} className="empty-icon" />
            <p>No new notifications</p>
          </div>
        ) : (
          notifications.map(n => (
            <Card key={n.id} margin="0 0 12px 0" style={{ opacity: n.read ? 0.6 : 1, borderLeft: n.read ? 'none' : '4px solid #f59e0b' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
                <div style={{ flex: 1 }}>
                  <h4 style={{ margin: '0 0 4px 0', fontWeight: n.read ? 500 : 700 }}>{n.title || 'System Alert'}</h4>
                  <p style={{ margin: 0, fontSize: '0.9rem', color: 'var(--text-color)', opacity: 0.8 }}>{n.message || n.body}</p>
                  <p style={{ margin: '8px 0 0 0', fontSize: '0.75rem', color: '#64748b' }}>
                    {new Date(n.createdAt?.seconds ? n.createdAt.seconds * 1000 : n.createdAt || Date.now()).toLocaleString()}
                  </p>
                </div>
                <div style={{ display: 'flex', gap: '8px' }}>
                  {!n.read && (
                    <button className="icon-btn" onClick={() => handleMarkAsRead(n)} style={{ color: '#10b981' }}>
                      <Check size={20} />
                    </button>
                  )}
                  <button className="icon-btn" onClick={() => handleDelete(n)} style={{ color: '#ef4444' }}>
                    <Trash2 size={20} />
                  </button>
                </div>
              </div>
            </Card>
          ))
        )}
      </div>
    </div>
  );
};

export default Notifications;
