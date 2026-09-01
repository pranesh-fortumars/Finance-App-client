import React, { useState, useMemo } from 'react';
import { useDataContext } from '../context/DataContext';
import Card from '../components/common/Card';
import { Download, Printer, Filter, Calendar, BarChart3, PieChart } from 'lucide-react';
import './Pages.css';

const Reports = () => {
  const { transactions, users, isLoading } = useDataContext();
  const [period, setPeriod] = useState('monthly');
  const [client, setClient] = useState('all');

  const filteredData = useMemo(() => {
    let txs = [...transactions];
    
    // Filter by client
    if (client !== 'all') {
      txs = txs.filter(t => t.userId === client);
    }

    // Filter by period
    const now = new Date();
    txs = txs.filter(t => {
      const d = new Date(t.date?.seconds ? t.date.seconds * 1000 : t.date);
      if (period === 'daily') return d.getDate() === now.getDate() && d.getMonth() === now.getMonth() && d.getFullYear() === now.getFullYear();
      if (period === 'monthly') return d.getMonth() === now.getMonth() && d.getFullYear() === now.getFullYear();
      if (period === 'yearly') return d.getFullYear() === now.getFullYear();
      if (period === 'weekly') {
        const weekAgo = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
        return d >= weekAgo;
      }
      return true;
    });

    const totalAmt = txs.reduce((sum, t) => sum + (Number(t.amount) || 0), 0);
    const uniqueClients = new Set(txs.map(t => t.userId)).size;
    const avg = txs.length ? totalAmt / txs.length : 0;

    return { txs, totalAmt, uniqueClients, avg };
  }, [transactions, period, client]);

  const getClientName = () => {
    if (client === 'all') return 'All Clients';
    const u = users.find(u => u.id === client);
    return u?.name || 'Unknown Client';
  };

  if (isLoading) return <div className="screen-center">Loading Analytics...</div>;

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
                {users.map(u => (
                  <option key={u.id} value={u.id}>{u.name}</option>
                ))}
              </select>
            </div>
          </div>
        </Card>

        <div style={{ padding: '12px', backgroundColor: 'rgba(59, 130, 246, 0.1)', borderRadius: '8px', border: '1px solid rgba(59, 130, 246, 0.3)', display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '16px', color: '#3b82f6', fontWeight: 500 }}>
          <Filter size={18} /> Showing data for {getClientName()} ({period.toUpperCase()} view)
        </div>

        <div className="stats-grid">
          <Card padding="16px">
            <div className="stat-title">Total Amount</div>
            <div className="stat-value" style={{ color: '#3b82f6' }}>₹{filteredData.totalAmt.toFixed(2)}</div>
          </Card>
          <Card padding="16px">
            <div className="stat-title">Transactions</div>
            <div className="stat-value" style={{ color: '#10b981' }}>{filteredData.txs.length}</div>
          </Card>
          <Card padding="16px">
            <div className="stat-title">Average</div>
            <div className="stat-value" style={{ color: '#f59e0b' }}>₹{filteredData.avg.toFixed(2)}</div>
          </Card>
          <Card padding="16px">
            <div className="stat-title">Clients</div>
            <div className="stat-value" style={{ color: '#8b5cf6' }}>{filteredData.uniqueClients}</div>
          </Card>
        </div>

        <Card title="Payment Mode Distribution" margin="0 0 16px 0">
          <div className="center-message" style={{ height: 200 }}>
            <PieChart size={48} className="empty-icon" />
            <p>Chart coming soon</p>
          </div>
        </Card>
      </div>
    </div>
  );
};

export default Reports;
