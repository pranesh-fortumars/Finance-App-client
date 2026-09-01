import React, { useState } from 'react';
import Card from '../components/common/Card';
import { Search, Filter, Calendar } from 'lucide-react';
import './Pages.css';

const PaymentHandling = () => {
  const [paymentMode, setPaymentMode] = useState('all');

  return (
    <div className="page-container">
      <div className="welcome-banner" style={{ marginBottom: 0, borderBottomLeftRadius: 0, borderBottomRightRadius: 0 }}>
        <h2>Payment Handling</h2>
        <p>Manage and track all payments</p>
      </div>

      <div style={{ backgroundColor: 'var(--card-bg, #ffffff)', padding: '20px', borderBottomLeftRadius: '16px', borderBottomRightRadius: '16px', marginBottom: '20px', boxShadow: '0 1px 3px rgba(0,0,0,0.05)' }}>
        <div className="search-container" style={{ marginBottom: '16px' }}>
          <Search size={20} className="search-icon" />
          <input 
            type="text" 
            placeholder="Search by name, amount, or ID..."
            className="search-input"
          />
        </div>

        <div style={{ display: 'flex', gap: '12px' }}>
          <div style={{ flex: 1 }}>
            <select 
              className="form-select"
              value={paymentMode}
              onChange={(e) => setPaymentMode(e.target.value)}
            >
              <option value="all">All Modes</option>
              <option value="offline">Offline</option>
              <option value="card">Card</option>
              <option value="upi">UPI</option>
              <option value="netbanking">Net Banking</option>
            </select>
          </div>
          <div style={{ flex: 1 }} className="input-wrapper">
            <Calendar size={20} className="input-icon" />
            <input type="date" className="form-input" style={{ paddingLeft: '40px' }} />
          </div>
        </div>
      </div>

      <div className="list-container">
        <div className="center-message">
          <Receipt size={48} className="empty-icon" />
          <p>No payments found</p>
          <span style={{ fontSize: '0.85rem', opacity: 0.6 }}>Try adjusting your search or filters</span>
        </div>
      </div>
    </div>
  );
};

// Quick polyfill icon just for the empty state
const Receipt = ({ size, className }) => (
  <svg xmlns="http://www.w3.org/2000/svg" width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className={className}>
    <path d="M4 2v20l2-1 2 1 2-1 2 1 2-1 2 1 2-1 2 1V2l-2 1-2-1-2 1-2-1-2 1-2-1-2 1-2-1Z"/>
    <path d="M16 8h-6a2 2 0 1 0 0 4h4a2 2 0 1 1 0 4H8"/>
    <path d="M12 17.5v-11"/>
  </svg>
);

export default PaymentHandling;
