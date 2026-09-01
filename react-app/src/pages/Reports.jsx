import React, { useState, useMemo } from 'react';
import { useDataContext } from '../context/DataContext';
import Card from '../components/common/Card';
import { Download, Printer, Filter, BarChart3 } from 'lucide-react';
import { PieChart, Pie, Cell, Tooltip, ResponsiveContainer, BarChart, Bar, XAxis, YAxis, CartesianGrid } from 'recharts';
import './Pages.css';

const COLORS = ['#0088FE', '#00C49F', '#FFBB28', '#FF8042'];

const Reports = () => {
  const { transactions, users, isLoading } = useDataContext();
  const [period, setPeriod] = useState('monthly');
  const [client, setClient] = useState('all');

  const { txs, totalAmt, uniqueClients, avg, paymentData, timelineData } = useMemo(() => {
    let txList = [...transactions];
    
    // Filter by client
    if (client !== 'all') {
      txList = txList.filter(t => t.userId === client);
    }

    // Filter by period
    const now = new Date();
    txList = txList.filter(t => {
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

    const tAmt = txList.reduce((sum, t) => sum + (Number(t.amount) || 0), 0);
    const uClients = new Set(txList.map(t => t.userId)).size;
    const tAvg = txList.length ? tAmt / txList.length : 0;

    // Calculate Payment Mode Data for Pie Chart
    const pModes = {};
    txList.forEach(t => {
      const mode = t.paymentMode || 'unknown';
      pModes[mode] = (pModes[mode] || 0) + (Number(t.amount) || 0);
    });
    const pData = Object.keys(pModes).map(key => ({ name: key.toUpperCase(), value: pModes[key] }));

    // Calculate Timeline Data for Bar Chart
    const tLine = {};
    txList.forEach(t => {
      const d = new Date(t.date?.seconds ? t.date.seconds * 1000 : t.date).toLocaleDateString();
      tLine[d] = (tLine[d] || 0) + (Number(t.amount) || 0);
    });
    const tData = Object.keys(tLine).map(key => ({ date: key, amount: tLine[key] })).sort((a,b) => new Date(a.date) - new Date(b.date));

    return { txs: txList, totalAmt: tAmt, uniqueClients: uClients, avg: tAvg, paymentData: pData, timelineData: tData };
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
            <div className="stat-value" style={{ color: '#3b82f6' }}>₹{totalAmt.toFixed(2)}</div>
          </Card>
          <Card padding="16px">
            <div className="stat-title">Transactions</div>
            <div className="stat-value" style={{ color: '#10b981' }}>{txs.length}</div>
          </Card>
          <Card padding="16px">
            <div className="stat-title">Average</div>
            <div className="stat-value" style={{ color: '#f59e0b' }}>₹{avg.toFixed(2)}</div>
          </Card>
          <Card padding="16px">
            <div className="stat-title">Clients</div>
            <div className="stat-value" style={{ color: '#8b5cf6' }}>{uniqueClients}</div>
          </Card>
        </div>

        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px', marginBottom: '16px' }}>
          <Card title="Payment Mode Distribution" margin="0">
            <div style={{ height: 300, width: '100%' }}>
              {paymentData.length > 0 ? (
                <ResponsiveContainer width="100%" height="100%">
                  <PieChart>
                    <Pie data={paymentData} cx="50%" cy="50%" innerRadius={60} outerRadius={100} paddingAngle={5} dataKey="value">
                      {paymentData.map((entry, index) => <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />)}
                    </Pie>
                    <Tooltip formatter={(value) => `₹${value.toFixed(2)}`} />
                  </PieChart>
                </ResponsiveContainer>
              ) : (
                <div className="center-message"><p>No payment data available</p></div>
              )}
            </div>
          </Card>

          <Card title="Collection Timeline" margin="0">
            <div style={{ height: 300, width: '100%' }}>
              {timelineData.length > 0 ? (
                <ResponsiveContainer width="100%" height="100%">
                  <BarChart data={timelineData} margin={{ top: 20, right: 30, left: 20, bottom: 5 }}>
                    <CartesianGrid strokeDasharray="3 3" opacity={0.2} />
                    <XAxis dataKey="date" tick={{fontSize: 12}} />
                    <YAxis tick={{fontSize: 12}} />
                    <Tooltip cursor={{fill: 'rgba(59,130,246,0.1)'}} formatter={(value) => `₹${value.toFixed(2)}`} />
                    <Bar dataKey="amount" fill="#3b82f6" radius={[4, 4, 0, 0]} />
                  </BarChart>
                </ResponsiveContainer>
              ) : (
                <div className="center-message"><p>No timeline data available</p></div>
              )}
            </div>
          </Card>
        </div>
      </div>
    </div>
  );
};

export default Reports;
