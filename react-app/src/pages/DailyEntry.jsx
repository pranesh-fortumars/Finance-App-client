import React, { useState } from 'react';
import Card from '../components/common/Card';
import Button from '../components/common/Button';
import { Search, Calendar, Check, Receipt } from 'lucide-react';
import './Pages.css';

const DailyEntry = () => {
  const [amount, setAmount] = useState('');
  const [remarks, setRemarks] = useState('');
  const [paymentMode, setPaymentMode] = useState('offline');

  return (
    <div className="page-container">
      <div className="page-header">
        <h2 style={{ margin: 0, display: 'flex', alignItems: 'center', gap: '8px' }}>
          <Receipt size={24} color="#3b82f6" /> Daily Entry
        </h2>
      </div>

      <div className="list-container">
        <Card title="Transaction Details" margin="0 0 24px 0">
          <div className="form-group">
            <label className="form-label">Search User</label>
            <div className="search-container" style={{ marginBottom: '16px' }}>
              <Search size={20} className="search-icon" />
              <input 
                type="text" 
                placeholder="Search users by name, mobile..."
                className="search-input"
              />
            </div>
          </div>

          <div className="form-group">
            <label className="form-label">Amount</label>
            <div className="input-wrapper">
              <span className="input-prefix">₹</span>
              <input 
                type="number" 
                className="form-input" 
                value={amount}
                onChange={(e) => setAmount(e.target.value)}
                placeholder="0.00"
              />
            </div>
          </div>

          <div className="form-group">
            <label className="form-label">Payment Mode</label>
            <select 
              className="form-select"
              value={paymentMode}
              onChange={(e) => setPaymentMode(e.target.value)}
            >
              <option value="offline">Offline</option>
              <option value="card">Card</option>
              <option value="upi">UPI</option>
              <option value="netbanking">Net Banking</option>
            </select>
          </div>

          <div className="form-group">
            <label className="form-label">Transaction Date</label>
            <div className="input-wrapper">
              <Calendar size={20} className="input-icon" />
              <input type="date" className="form-input" defaultValue={new Date().toISOString().split('T')[0]} />
            </div>
          </div>

          <div className="form-group">
            <label className="form-label">Remarks (Optional)</label>
            <textarea 
              className="form-input" 
              rows={3}
              value={remarks}
              onChange={(e) => setRemarks(e.target.value)}
              placeholder="Enter remarks..."
            />
          </div>

          <Button 
            text="Done" 
            icon={Check} 
            width="100%" 
            onClick={() => alert("Transaction logic pending!")} 
          />
        </Card>

        <Card title="Recent Transactions">
          <div className="center-message" style={{ height: 100 }}>
            <p>No recent transactions</p>
          </div>
        </Card>
      </div>
    </div>
  );
};

export default DailyEntry;
