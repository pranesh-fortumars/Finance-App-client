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
import BonusManagement from '../../pages/BonusManagement';
import Notifications from '../../pages/Notifications';
import SchemeManagement from '../../pages/SchemeManagement';

const ScreenWidget = ({ viewId }) => {
  switch (viewId) {
    case ViewId.DASHBOARD: return <Dashboard />;
    case ViewId.USERS: return <UserManagement />;
    case ViewId.ENTRY: return <DailyEntry />;
    case ViewId.REPORTS: return <Reports />;
    case ViewId.PAYMENTS: return <PaymentHandling />;
    case ViewId.NOTIFICATIONS: return <Notifications />;
    case ViewId.BONUS: return <BonusManagement />;
    case ViewId.SCHEMES: return <SchemeManagement />;
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
