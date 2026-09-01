import React from 'react';
import AppBar from './AppBar';
import BottomNav from './BottomNav';
import { useAppContext, ViewId } from '../../context/AppContext';
import './Layout.css';

import UserManagement from '../../pages/UserManagement';
import Dashboard from '../../pages/Dashboard';
import DailyEntry from '../../pages/DailyEntry';
import PaymentHandling from '../../pages/PaymentHandling';
import Reports from '../../pages/Reports';

const ScreenWidget = ({ viewId }) => {
  switch (viewId) {
    case ViewId.DASHBOARD: return <Dashboard />;
    case ViewId.USERS: return <UserManagement />;
    case ViewId.ENTRY: return <DailyEntry />;
    case ViewId.REPORTS: return <Reports />;
    case ViewId.PAYMENTS: return <PaymentHandling />;
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
