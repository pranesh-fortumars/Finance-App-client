import React from 'react';
import { useAppContext, ViewId } from '../../context/AppContext';
import { LayoutDashboard, Users, PlusCircle, BarChart3, Wallet } from 'lucide-react';
import './Layout.css';

const navItems = [
  { id: ViewId.DASHBOARD, icon: LayoutDashboard, label: 'Dashboard' },
  { id: ViewId.USERS, icon: Users, label: 'Users' },
  { id: ViewId.ENTRY, icon: PlusCircle, label: 'Entry' },
  { id: ViewId.REPORTS, icon: BarChart3, label: 'Reports' },
  { id: ViewId.PAYMENTS, icon: Wallet, label: 'Payments' }
];

const BottomNav = () => {
  const { currentView, setCurrentView, isDarkMode } = useAppContext();

  return (
    <nav className={`bottom-nav ${isDarkMode ? 'dark' : 'light'}`}>
      {navItems.map((item) => {
        const Icon = item.icon;
        const isActive = currentView === item.id;
        return (
          <div 
            key={item.id} 
            className={`nav-item ${isActive ? 'active' : ''}`}
            onClick={() => setCurrentView(item.id)}
          >
            <Icon size={24} />
            <span className="nav-label">{item.label}</span>
          </div>
        );
      })}
    </nav>
  );
};

export default BottomNav;
