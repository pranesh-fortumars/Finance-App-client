import React, { createContext, useContext, useState, useEffect } from 'react';

// Mirroring Flutter's ViewId Enum
export const ViewId = {
  DASHBOARD: 'dashboard',
  USERS: 'users',
  ENTRY: 'entry',
  REPORTS: 'reports',
  PAYMENTS: 'payments',
  NOTIFICATIONS: 'notifications',
  BONUS: 'bonus'
};

const AppContext = createContext();

export const AppProvider = ({ children }) => {
  // Mirroring NavigationProvider
  const [currentView, setCurrentView] = useState(ViewId.DASHBOARD);

  // Mirroring ThemeProvider
  const [isDarkMode, setIsDarkMode] = useState(true);

  const toggleTheme = () => {
    setIsDarkMode(prev => !prev);
  };

  useEffect(() => {
    // Apply theme to document body
    if (isDarkMode) {
      document.body.classList.add('dark');
      document.body.classList.remove('light');
    } else {
      document.body.classList.add('light');
      document.body.classList.remove('dark');
    }
  }, [isDarkMode]);

  return (
    <AppContext.Provider value={{
      currentView,
      setCurrentView,
      isDarkMode,
      toggleTheme
    }}>
      {children}
    </AppContext.Provider>
  );
};

export const useAppContext = () => useContext(AppContext);
