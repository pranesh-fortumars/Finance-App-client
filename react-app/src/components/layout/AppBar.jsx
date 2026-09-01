import React from 'react';
import { useAppContext, ViewId } from '../../context/AppContext';
import { Moon, Sun } from 'lucide-react';
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
    default: return 'Finance Tracker';
  }
};

const AppBar = () => {
  const { currentView, isDarkMode, toggleTheme } = useAppContext();

  return (
    <header className={`app-bar ${isDarkMode ? 'dark' : 'light'}`}>
      <h1 className="app-title">{getTitle(currentView)}</h1>
      <button className="theme-toggle" onClick={toggleTheme}>
        {isDarkMode ? <Sun size={24} /> : <Moon size={24} />}
      </button>
    </header>
  );
};

export default AppBar;
