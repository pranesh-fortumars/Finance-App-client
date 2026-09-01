import React from 'react';
import { useAppContext, ViewId } from '../../context/AppContext';
import { Moon, Sun, Bell, Gift, Layers } from 'lucide-react';
import './Layout.css';

const getTitle = (viewId) => {
  switch (viewId) {
    case ViewId.DASHBOARD: return 'Dashboard';
    case ViewId.USERS: return 'User Management';
    case ViewId.ENTRY: return 'Daily Entry';
    case ViewId.REPORTS: return 'Reports';
    case ViewId.PAYMENTS: return 'Payment Handling';
    case ViewId.NOTIFICATIONS: return 'Notifications';
    case ViewId.BONUS: return 'Bonus Management';
    case ViewId.SCHEMES: return 'Scheme Management';
    default: return 'Finance Tracker';
  }
};

const AppBar = () => {
  const { currentView, setCurrentView, isDarkMode, toggleTheme } = useAppContext();

  return (
    <header className={`app-bar ${isDarkMode ? 'dark' : 'light'}`}>
      <h1 className="app-title">{getTitle(currentView)}</h1>
      <div style={{ display: 'flex', gap: '16px', alignItems: 'center' }}>
        <button className="icon-btn" onClick={() => setCurrentView(ViewId.SCHEMES)} style={{ color: currentView === ViewId.SCHEMES ? '#8b5cf6' : 'inherit' }}>
          <Layers size={22} />
        </button>
        <button className="icon-btn" onClick={() => setCurrentView(ViewId.BONUS)} style={{ color: currentView === ViewId.BONUS ? '#10b981' : 'inherit' }}>
          <Gift size={22} />
        </button>
        <button className="icon-btn" onClick={() => setCurrentView(ViewId.NOTIFICATIONS)} style={{ color: currentView === ViewId.NOTIFICATIONS ? '#f59e0b' : 'inherit' }}>
          <Bell size={22} />
        </button>
        <button className="theme-toggle" onClick={toggleTheme}>
          {isDarkMode ? <Sun size={24} /> : <Moon size={24} />}
        </button>
      </div>
    </header>
  );
};

export default AppBar;
