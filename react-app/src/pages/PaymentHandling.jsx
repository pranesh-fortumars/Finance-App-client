import React, { useState, useEffect } from 'react';
import { useDataContext } from '../context/DataContext';
import Card from '../components/common/Card';
import { Search, Filter, Calendar } from 'lucide-react';
import './Pages.css';

const PaymentHandling = () => {
  const { transactions, users, isLoading } = useDataContext();
  const [paymentMode, setPaymentMode] = useState('all');
  const [searchQuery, setSearchQuery] = useState('');
  const [date, setDate] = useState('');
  const [filteredTx, setFilteredTx] = useState([]);

  useEffect(() => {
    let filtered = [...transactions];

    if (searchQuery) {
      const q = searchQuery.toLowerCase();
      filtered = filtered.filter(t => {
        const u = users.find(user => user.id === t.userId);
        return (
          t.receiptNumber?.toLowerCase().includes(q) ||
          t.amount?.toString().includes(q) ||
          u?.name?.toLowerCase().includes(q)
        );
      });
    }

    if (paymentMode !== 'all') {
      filtered = filtered.filter(t => t.paymentMode === paymentMode);
    }

    if (date) {
      filtered = filtered.filter(t => {
        const tDate = new Date(t.date?.seconds ? t.date.seconds * 1000 : t.date).toISOString().split('T')[0];
        return tDate === date;
      });
    }

    setFilteredTx(filtered);
  }, [transactions, users, searchQuery, paymentMode, date]);

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
            value={searchQuery}
            onChange={e => setSearchQuery(e.target.value)}
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
            <input type="date" className="form-input" style={{ paddingLeft: '40px' }} value={date} onChange={e => setDate(e.target.value)} />
          </div>
        </div>
      </div>

      <div className="list-container">
        {isLoading ? (
           <div className="center-message">Loading payments...</div>
        ) : filteredTx.length === 0 ? (
          <div className="center-message">
            <Receipt size={48} className="empty-icon" />
            <p>No payments found</p>
            <span style={{ fontSize: '0.85rem', opacity: 0.6 }}>Try adjusting your search or filters</span>
          </div>
        ) : (
          filteredTx.map(t => {
            const u = users.find(user => user.id === t.userId);
            return (
              <Card key={t.id} margin="0 0 12px 0">
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                  <div>
                    <h4 style={{ margin: '0 0 4px 0' }}>{u?.name || 'Unknown'}</h4>
                    <p style={{ margin: 0, fontSize: '0.85rem', color: '#64748b' }}>{u?.mobileNumber || ''}</p>
                  </div>
                  <div style={{ textAlign: 'right' }}>
                    <div style={{ fontWeight: 'bold', fontSize: '1.1rem' }}>₹{Number(t.amount).toFixed(2)}</div>
                    <div style={{ fontSize: '0.75rem', padding: '2px 8px', borderRadius: '12px', background: 'rgba(59,130,246,0.1)', color: '#3b82f6', display: 'inline-block', marginTop: '4px' }}>
                      {t.paymentMode.toUpperCase()}
                    </div>
                  </div>
                </div>
                <div style={{ display: 'flex', gap: '16px', marginTop: '12px', paddingTop: '12px', borderTop: '1px solid var(--border-color, rgba(0,0,0,0.05))', fontSize: '0.8rem', color: '#64748b' }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '4px' }}>
                    <Calendar size={14} /> {new Date(t.date?.seconds ? t.date.seconds * 1000 : t.date).toLocaleDateString()}
                  </div>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '4px' }}>
                    <Receipt size={14} /> {t.receiptNumber || 'N/A'}
                  </div>
                </div>
              </Card>
            );
          })
        )}
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
