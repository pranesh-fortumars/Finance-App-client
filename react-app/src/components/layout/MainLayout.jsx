import React from 'react';
import AppBar from './AppBar';
import BottomNav from './BottomNav';
import { useAppContext, ViewId } from '../../context/AppContext';
import './Layout.css';

import UserManagement from '../../pages/UserManagement';
import Dashboard from '../../pages/Dashboard';

const ScreenWidget = ({ viewId }) => {
  switch (viewId) {
    case ViewId.DASHBOARD: return <Dashboard />;
    case ViewId.USERS: return <UserManagement />;
    case ViewId.ENTRY: return <div className="screen-center">Daily Entry (Pending)</div>;
    case ViewId.REPORTS: return <div className="screen-center">Reports (Pending)</div>;
    case ViewId.PAYMENTS: return <div className="screen-center">Payment Handling (Pending)</div>;
    case ViewId.NOTIFICATIONS: return <div className="screen-center">Notifications (Pending)</div>;
    case ViewId.BONUS: return <div className="screen-center">Bonus Management (Pending)</div>;
    default: return <div className="screen-center">Unknown View</div>;
  }
};

const MainLayout = () => {
  const { currentView, isDarkMode } = useAppContext();

  return (
    <div className={`main-layout ${isDarkMode ? 'dark-bg' : 'light-bg'}`}>
      <AppBar />
      <main className="content-area">
        <ScreenWidget viewId={currentView} />
      </main>
      <BottomNav />
    </div>
  );
};

export default MainLayout;
