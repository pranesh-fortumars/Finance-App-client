import React from 'react';
import Card from '../components/common/Card';
import { Users, Landmark, TrendingUp, Clock, CheckCircle, IndianRupee } from 'lucide-react';
import { useDataContext } from '../context/DataContext';
import './Pages.css';
import './Dashboard.css';

const StatCard = ({ title, value, icon: Icon, color, change, isPositive }) => (
  <Card padding="16px">
    <div className="stat-card-header">
      <div className="stat-icon" style={{ backgroundColor: `${color}1A`, color }}>
        <Icon size={20} />
      </div>
      <div className={`stat-badge ${isPositive ? 'positive' : 'negative'}`}>
        {change}
      </div>
    </div>
    <div className="stat-value">{value}</div>
    <div className="stat-title">{title}</div>
  </Card>
);

const Dashboard = () => {
  const { users, userSchemes, transactions, isLoading } = useDataContext();

  if (isLoading) {
    return <div className="screen-center">Loading Dashboard...</div>;
  }

  const today = new Date();
  const isToday = (dateStr) => {
    const d = new Date(dateStr?.seconds ? dateStr.seconds * 1000 : dateStr);
    return d.getDate() === today.getDate() && d.getMonth() === today.getMonth() && d.getFullYear() === today.getFullYear();
  };

  const totalCustomers = users.length;
  const activeSchemes = userSchemes.filter(s => s.status === 'active' || !s.status).length;
  const completedCycles = userSchemes.filter(s => s.status === 'completed').length;
  
  const totalInvestment = transactions.reduce((sum, t) => sum + (Number(t.amount) || 0), 0);
  const pendingDues = userSchemes.reduce((sum, s) => sum + ((s.totalAmount || 0) - (s.currentBalance || 0)), 0);
  const todayCollection = transactions.filter(t => isToday(t.date)).reduce((sum, t) => sum + (Number(t.amount) || 0), 0);

  const recentTransactions = [...transactions].sort((a, b) => {
    const dA = new Date(a.date?.seconds ? a.date.seconds * 1000 : a.date);
    const dB = new Date(b.date?.seconds ? b.date.seconds * 1000 : b.date);
    return dB - dA;
  }).slice(0, 5);

  return (
    <div className="page-container">
      <div className="welcome-banner">
        <h2>Good Afternoon!</h2>
        <p>Welcome to your finance dashboard</p>
      </div>

      <div className="list-container" style={{ paddingBottom: '20px' }}>
        <div className="stats-grid">
          <StatCard title="Total Customers" value={totalCustomers} icon={Users} color="#3B82F6" change="+12%" isPositive={true} />
          <StatCard title="Active Schemes" value={activeSchemes} icon={Landmark} color="#10B981" change="+5%" isPositive={true} />
          <StatCard title="Total Investment" value={`₹${totalInvestment.toFixed(2)}`} icon={TrendingUp} color="#8B5CF6" change="+8%" isPositive={true} />
          <StatCard title="Pending Dues" value={`₹${pendingDues.toFixed(2)}`} icon={Clock} color="#F59E0B" change="-2%" isPositive={true} />
          <StatCard title="Completed Cycles" value={completedCycles} icon={CheckCircle} color="#06B6D4" change="+1" isPositive={true} />
          <StatCard title="Today's Collection" value={`₹${todayCollection.toFixed(2)}`} icon={IndianRupee} color="#EC4899" change="+15%" isPositive={true} />
        </div>

        <div className="section-header">
          <h3>Recent Transactions</h3>
          <button className="view-all-btn">View All</button>
        </div>
        
        <Card>
          {recentTransactions.length === 0 ? (
            <div className="center-message" style={{ height: 100 }}>
              <p>No recent transactions</p>
            </div>
          ) : (
            <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
              {recentTransactions.map(t => {
                const user = users.find(u => u.id === t.userId);
                return (
                  <div key={t.id} style={{ display: 'flex', justifyContent: 'space-between', padding: '8px 0', borderBottom: '1px solid var(--border-color, rgba(0,0,0,0.05))' }}>
                    <div>
                      <div style={{ fontWeight: 600 }}>{user?.name || 'Unknown'}</div>
                      <div style={{ fontSize: '0.8rem', color: '#64748b' }}>{t.paymentMode.toUpperCase()}</div>
                    </div>
                    <div style={{ fontWeight: 600, color: '#10b981' }}>+ ₹{Number(t.amount).toFixed(2)}</div>
                  </div>
                )
              })}
            </div>
          )}
        </Card>
      </div>
    </div>
  );
};

export default Dashboard;
