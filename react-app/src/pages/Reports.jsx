import React, { useState } from 'react';
import Card from '../components/common/Card';
import { Download, Printer, Filter, Calendar, BarChart3, PieChart } from 'lucide-react';
import './Pages.css';

const Reports = () => {
  const [period, setPeriod] = useState('monthly');
  const [client, setClient] = useState('all');

  return (
    <div className="page-container">
      <div className="page-header" style={{ justifyContent: 'space-between' }}>
        <h2 style={{ margin: 0, display: 'flex', alignItems: 'center', gap: '8px' }}>
          <BarChart3 size={24} color="#3b82f6" /> Analytics
        </h2>
        <div style={{ display: 'flex', gap: '12px' }}>
          <button className="icon-btn"><Download size={20} /></button>
          <button className="icon-btn"><Printer size={20} /></button>
        </div>
      </div>

      <div className="list-container">
        <Card title="Filters" margin="0 0 16px 0">
          <div className="form-group">
            <label className="form-label">Date Range</label>
            <div className="input-wrapper">
              <Calendar size={20} className="input-icon" />
              <input type="text" className="form-input" placeholder="Select date range" readOnly />
            </div>
          </div>
          <div style={{ display: 'flex', gap: '12px' }}>
            <div className="form-group" style={{ flex: 1 }}>
              <label className="form-label">Period</label>
              <select className="form-select" value={period} onChange={e => setPeriod(e.target.value)}>
                <option value="daily">Daily</option>
                <option value="weekly">Weekly</option>
                <option value="monthly">Monthly</option>
                <option value="yearly">Yearly</option>
              </select>
            </div>
            <div className="form-group" style={{ flex: 1 }}>
              <label className="form-label">Client</label>
              <select className="form-select" value={client} onChange={e => setClient(e.target.value)}>
                <option value="all">All Clients</option>
              </select>
            </div>
          </div>
        </Card>

        <div style={{ padding: '12px', backgroundColor: 'rgba(59, 130, 246, 0.1)', borderRadius: '8px', border: '1px solid rgba(59, 130, 246, 0.3)', display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '16px', color: '#3b82f6', fontWeight: 500 }}>
          <Filter size={18} /> Showing data for All Clients (MONTHLY view)
        </div>

        <div className="stats-grid">
          <Card padding="16px">
            <div className="stat-title">Total Amount</div>
            <div className="stat-value" style={{ color: '#3b82f6' }}>₹0.00</div>
          </Card>
          <Card padding="16px">
            <div className="stat-title">Transactions</div>
            <div className="stat-value" style={{ color: '#10b981' }}>0</div>
          </Card>
          <Card padding="16px">
            <div className="stat-title">Average</div>
            <div className="stat-value" style={{ color: '#f59e0b' }}>₹0.00</div>
          </Card>
          <Card padding="16px">
            <div className="stat-title">Clients</div>
            <div className="stat-value" style={{ color: '#8b5cf6' }}>0</div>
          </Card>
        </div>

        <Card title="Payment Mode Distribution" margin="0 0 16px 0">
          <div className="center-message" style={{ height: 200 }}>
            <PieChart size={48} className="empty-icon" />
            <p>No payment data available</p>
          </div>
        </Card>
      </div>
    </div>
  );
};

export default Reports;
