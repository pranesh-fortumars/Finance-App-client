import React, { useState, useEffect } from 'react';
import { useDataContext } from '../context/DataContext';
import { FirebaseService } from '../services/firebase';
import Card from '../components/common/Card';
import Button from '../components/common/Button';
import { Search, Calendar, Check, Receipt, X } from 'lucide-react';
import './Pages.css';

const DailyEntry = () => {
  const { users, userSchemes, transactions, refreshData } = useDataContext();
  
  const [searchQuery, setSearchQuery] = useState('');
  const [filteredUsers, setFilteredUsers] = useState([]);
  const [selectedUser, setSelectedUser] = useState(null);
  
  const [amount, setAmount] = useState('');
  const [remarks, setRemarks] = useState('');
  const [paymentMode, setPaymentMode] = useState('offline');
  const [date, setDate] = useState(new Date().toISOString().split('T')[0]);
  const [isSaving, setIsSaving] = useState(false);

  useEffect(() => {
    if (!searchQuery) {
      setFilteredUsers([]);
      return;
    }
    const query = searchQuery.toLowerCase();
    setFilteredUsers(users.filter(u => 
      u.name.toLowerCase().includes(query) || 
      u.mobileNumber.includes(query) || 
      u.serialNumber.toLowerCase().includes(query)
    ));
  }, [searchQuery, users]);

  const handleSave = async () => {
    if (!selectedUser || !amount || isNaN(Number(amount))) {
      alert("Please select a user and enter a valid amount.");
      return;
    }

    setIsSaving(true);
    try {
      const amt = Number(amount);
      const transaction = {
        id: Date.now().toString(),
        userId: selectedUser.id,
        schemeId: 'default', // Ideally derived from userSchemes
        amount: amt,
        paymentMode,
        date: new Date(date).toISOString(),
        receiptNumber: `RCP${Date.now()}`,
        remarks: remarks || null
      };

      await FirebaseService.saveTransaction(transaction);

      // Update scheme balance
      const scheme = userSchemes.find(s => s.userId === selectedUser.id);
      if (scheme) {
        await FirebaseService.saveUserScheme({
          ...scheme,
          currentBalance: (scheme.currentBalance || 0) + amt
        });
      }

      await refreshData();
      
      // Reset form
      setSelectedUser(null);
      setSearchQuery('');
      setAmount('');
      setRemarks('');
      alert(`Transaction saved! Amount: ₹${amt.toFixed(2)}`);
    } catch (e) {
      alert("Error saving transaction: " + e.message);
    } finally {
      setIsSaving(false);
    }
  };

  const recentTx = [...transactions].sort((a,b) => new Date(b.date) - new Date(a.date)).slice(0, 5);

  return (
    <div className="page-container">
      <div className="page-header">
        <h2 style={{ margin: 0, display: 'flex', alignItems: 'center', gap: '8px' }}>
          <Receipt size={24} color="#3b82f6" /> Daily Entry
        </h2>
      </div>

      <div className="list-container">
        <Card title="Transaction Details" margin="0 0 24px 0">
          
          {/* User Search & Select */}
          <div className="form-group">
            <label className="form-label">Select User</label>
            {selectedUser ? (
              <div style={{ padding: '12px', border: '1px solid #3b82f6', borderRadius: '8px', backgroundColor: 'rgba(59, 130, 246, 0.1)', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <div>
                  <div style={{ fontWeight: 600, color: '#3b82f6' }}>{selectedUser.name}</div>
                  <div style={{ fontSize: '0.8rem', color: '#64748b' }}>{selectedUser.serialNumber} • {selectedUser.mobileNumber}</div>
                </div>
                <button className="icon-btn" onClick={() => setSelectedUser(null)}><X size={18} color="#ef4444" /></button>
              </div>
            ) : (
              <div>
                <div className="search-container" style={{ marginBottom: '8px' }}>
                  <Search size={20} className="search-icon" />
                  <input 
                    type="text" 
                    placeholder="Search users by name, mobile..."
                    className="search-input"
                    value={searchQuery}
                    onChange={e => setSearchQuery(e.target.value)}
                  />
                </div>
                {filteredUsers.length > 0 && (
                  <div style={{ border: '1px solid var(--border-color, rgba(0,0,0,0.1))', borderRadius: '8px', maxHeight: '150px', overflowY: 'auto' }}>
                    {filteredUsers.map(u => (
                      <div 
                        key={u.id} 
                        style={{ padding: '10px 12px', borderBottom: '1px solid var(--border-color, rgba(0,0,0,0.05))', cursor: 'pointer' }}
                        onClick={() => { setSelectedUser(u); setSearchQuery(''); }}
                      >
                        <div style={{ fontWeight: 600 }}>{u.name}</div>
                        <div style={{ fontSize: '0.8rem', opacity: 0.7 }}>{u.serialNumber} • {u.mobileNumber}</div>
                      </div>
                    ))}
                  </div>
                )}
              </div>
            )}
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
              <input type="date" className="form-input" value={date} onChange={e => setDate(e.target.value)} />
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
            text={isSaving ? "Saving..." : "Done"} 
            icon={Check} 
            width="100%" 
            onClick={handleSave} 
            disabled={isSaving}
          />
        </Card>

        <Card title="Recent Transactions">
          {recentTx.length === 0 ? (
            <div className="center-message" style={{ height: 100 }}>
              <p>No recent transactions</p>
            </div>
          ) : (
            <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
              {recentTx.map(t => {
                const u = users.find(user => user.id === t.userId);
                return (
                  <div key={t.id} style={{ display: 'flex', justifyContent: 'space-between', borderBottom: '1px solid rgba(0,0,0,0.05)', paddingBottom: '8px' }}>
                    <div>
                      <div style={{ fontWeight: 600 }}>{u?.name || 'Unknown'}</div>
                      <div style={{ fontSize: '0.8rem', opacity: 0.6 }}>{new Date(t.date).toLocaleDateString()} • {t.paymentMode}</div>
                    </div>
                    <div style={{ fontWeight: 600, color: '#10b981' }}>₹{Number(t.amount).toFixed(2)}</div>
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

export default DailyEntry;
