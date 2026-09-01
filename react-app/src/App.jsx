import React from 'react';
import { AppProvider } from './context/AppContext';
import { DataProvider } from './context/DataContext';
import MainLayout from './components/layout/MainLayout';
import './index.css';

function App() {
  return (
    <AppProvider>
      <DataProvider>
        <MainLayout />
      </DataProvider>
    </AppProvider>
  );
}

export default App;
