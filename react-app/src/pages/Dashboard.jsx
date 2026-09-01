import React from 'react';
import Card from '../components/common/Card';
import { Users, Landmark, TrendingUp, Clock, CheckCircle, IndianRupee } from 'lucide-react';
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
  return (
    <div className="page-container">
      <div className="welcome-banner">
        <h2>Good Afternoon!</h2>
        <p>Welcome to your finance dashboard</p>
      </div>

      <div className="stats-grid">
        <StatCard title="Total Customers" value="0" icon={Users} color="#3B82F6" change="+0%" isPositive={true} />
        <StatCard title="Active Schemes" value="0" icon={Landmark} color="#10B981" change="+0%" isPositive={true} />
        <StatCard title="Total Investment" value="₹0.00" icon={TrendingUp} color="#8B5CF6" change="+0%" isPositive={true} />
        <StatCard title="Pending Dues" value="₹0" icon={Clock} color="#F59E0B" change="-0%" isPositive={true} />
        <StatCard title="Completed Cycles" value="0" icon={CheckCircle} color="#06B6D4" change="+0" isPositive={true} />
        <StatCard title="Today's Collection" value="₹0.00" icon={IndianRupee} color="#EC4899" change="+0%" isPositive={true} />
      </div>

      <div className="section-header">
        <h3>Recent Transactions</h3>
        <button className="view-all-btn">View All</button>
      </div>
      
      <Card>
        <div className="center-message" style={{ height: 100 }}>
          <p>No recent transactions</p>
        </div>
      </Card>
    </div>
  );
};

export default Dashboard;
