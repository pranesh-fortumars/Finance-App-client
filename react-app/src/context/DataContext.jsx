import React, { createContext, useContext, useState, useEffect } from 'react';
import { FirebaseService } from '../services/firebase';

const DataContext = createContext(null);

export const DataProvider = ({ children }) => {
  const [data, setData] = useState({
    users: [],
    transactions: [],
    userSchemes: [],
    schemeTypes: [],
    notifications: [],
    isLoading: true,
    error: null
  });

  const refreshData = async () => {
    setData(prev => ({ ...prev, isLoading: true, error: null }));
    try {
      const [users, transactions, userSchemes, schemeTypes, notifications] = await Promise.all([
        FirebaseService.getUsers(),
        FirebaseService.getTransactions(),
        FirebaseService.getUserSchemes(),
        FirebaseService.getSchemeTypes(),
        FirebaseService.getNotifications()
      ]);
      setData({
        users,
        transactions,
        userSchemes,
        schemeTypes,
        notifications,
        isLoading: false,
        error: null
      });
    } catch (error) {
      console.error("Failed to fetch data:", error);
      setData(prev => ({ ...prev, isLoading: false, error: error.message }));
    }
  };

  useEffect(() => {
    refreshData();
  }, []);

  return (
    <DataContext.Provider value={{ ...data, refreshData }}>
      {children}
    </DataContext.Provider>
  );
};

export const useDataContext = () => useContext(DataContext);
