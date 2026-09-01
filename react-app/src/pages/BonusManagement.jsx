import React, { useState, useMemo } from 'react';
import { useDataContext } from '../context/DataContext';
import { FirebaseService } from '../services/firebase';
import Card from '../components/common/Card';
import Button from '../components/common/Button';
import { Gift, PlusCircle, Users, Wallet } from 'lucide-react';
import './Pages.css';

const BonusManagement = () => {
  const { users, transactions, refreshData, isLoading } = useDataContext();
  const [selectedClient, setSelectedClient] = useState('all');
  const [showDialog, setShowDialog] = useState(false);
  
  // Dialog State
  const [dialogUser, setDialogUser] = useState('');
  const [dialogAmount, setDialogAmount] = useState('');
  const [dialogRemarks, setDialogRemarks] = useState('');
  const [isSaving, setIsSaving] = useState(false);

  const bonuses = useMemo(() => {
    let clientBonuses = {};
    
    transactions.forEach(t => {
      const interest = Number(t.interest) || 0;
      if (interest > 0) {
        clientBonuses[t.userId] = (clientBonuses[t.userId] || 0) + interest;
      }
    });
    
    return clientBonuses;
  }, [transactions]);

  const filteredTransactions = useMemo(() => {
    let txs = transactions.filter(t => (Number(t.interest) || 0) > 0);
    if (selectedClient !== 'all') {
      txs = txs.filter(t => t.userId === selectedClient);
    }
    return txs.sort((a, b) => new Date(b.date) - new Date(a.date));
  }, [transactions, selectedClient]);

  const totalBonusPaid = Object.values(bonuses).reduce((sum, val) => sum + val, 0);

  const handleGiveBonus = async () => {
    if (!dialogUser || !dialogAmount || isNaN(Number(dialogAmount))) {
      alert("Select a user and enter a valid bonus amount");
      return;
    }

    setIsSaving(true);
    try {
      const amt = Number(dialogAmount);
      const transaction = {
        id: Date.now().toString(),
        userId: dialogUser,
        schemeId: 'bonus',
        amount: 0,
        paymentMode: 'offline',
        date: new Date().toISOString(),
        interest: amt,
        remarks: `Extra Bonus: ${dialogRemarks || 'Manual bonus given'}`,
        receiptNumber: `BONUS${Date.now()}`
      };

      await FirebaseService.saveTransaction(transaction);
      await refreshData();
      
      setShowDialog(false);
      setDialogUser('');
      setDialogAmount('');
      setDialogRemarks('');
      alert("Bonus added successfully!");
    } catch (e) {
      alert("Error adding bonus: " + e.message);
    } finally {
      setIsSaving(false);
    }
  };

  if (isLoading) return <div className="screen-center">Loading Bonus...</div>;

  return (
    <div className="page-container">
      <div className="page-header" style={{ justifyContent: 'space-between' }}>
        <h2 style={{ margin: 0, display: 'flex', alignItems: 'center', gap: '8px' }}>
          <Gift size={24} color="#10b981" /> Bonus Management
        </h2>
        <Button text="Give Bonus" icon={PlusCircle} onClick={() => setShowDialog(true)} />
      </div>

      <div className="list-container">
        <div style={{ display: 'flex', gap: '16px', marginBottom: '16px' }}>
          <Card padding="16px" margin="0" style={{ flex: 1, backgroundColor: 'rgba(16, 185, 129, 0.1)', borderColor: 'rgba(16, 185, 129, 0.3)' }}>
            <Wallet size={32} color="#10b981" />
            <div style={{ marginTop: '12px', fontSize: '0.9rem', color: '#10b981', fontWeight: 600 }}>Total Bonus Paid</div>
            <div style={{ fontSize: '1.5rem', fontWeight: 'bold', color: '#10b981' }}>₹{totalBonusPaid.toFixed(2)}</div>
          </Card>
          <Card padding="16px" margin="0" style={{ flex: 1, backgroundColor: 'rgba(59, 130, 246, 0.1)', borderColor: 'rgba(59, 130, 246, 0.3)' }}>
            <Users size={32} color="#3b82f6" />
            <div style={{ marginTop: '12px', fontSize: '0.9rem', color: '#3b82f6', fontWeight: 600 }}>Clients with Bonus</div>
            <div style={{ fontSize: '1.5rem', fontWeight: 'bold', color: '#3b82f6' }}>{Object.keys(bonuses).length}</div>
          </Card>
        </div>

        <Card title="Filters" margin="0 0 16px 0">
          <div className="form-group">
            <label className="form-label">Client</label>
            <select className="form-select" value={selectedClient} onChange={e => setSelectedClient(e.target.value)}>
              <option value="all">All Clients</option>
              {users.map(u => (
                <option key={u.id} value={u.id}>{u.name} ({u.serialNumber})</option>
              ))}
            </select>
          </div>
        </Card>

        <Card title="Bonus Transactions" margin="0 0 16px 0">
          {filteredTransactions.length === 0 ? (
            <div className="center-message" style={{ height: 100 }}>
              <p>No bonus transactions found</p>
            </div>
          ) : (
            <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
              {filteredTransactions.map(t => {
                const u = users.find(user => user.id === t.userId);
                return (
                  <div key={t.id} style={{ display: 'flex', justifyContent: 'space-between', padding: '12px', backgroundColor: 'rgba(16, 185, 129, 0.05)', border: '1px solid rgba(16, 185, 129, 0.2)', borderRadius: '8px' }}>
                    <div>
                      <div style={{ fontWeight: 600 }}>{u?.name || 'Unknown'}</div>
                      <div style={{ fontSize: '0.8rem', opacity: 0.7 }}>{new Date(t.date?.seconds ? t.date.seconds * 1000 : t.date).toLocaleDateString()}</div>
                      <div style={{ fontSize: '0.85rem', color: '#3b82f6', marginTop: '4px' }}>{t.remarks}</div>
                    </div>
                    <div style={{ fontWeight: 600, color: '#10b981', fontSize: '1.1rem' }}>+ ₹{Number(t.interest).toFixed(2)}</div>
                  </div>
                )
              })}
            </div>
          )}
        </Card>
      </div>

      {showDialog && (
        <div style={{ position: 'fixed', inset: 0, backgroundColor: 'rgba(0,0,0,0.5)', zIndex: 100, display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '20px' }}>
          <div style={{ backgroundColor: 'var(--card-bg, #ffffff)', padding: '24px', borderRadius: '16px', width: '100%', maxWidth: '400px' }}>
            <h3 style={{ margin: '0 0 16px 0' }}>Give Extra Bonus</h3>
            
            <div className="form-group">
              <label className="form-label">Client</label>
              <select className="form-select" value={dialogUser} onChange={e => setDialogUser(e.target.value)}>
                <option value="">Select a Client...</option>
                {users.map(u => (
                  <option key={u.id} value={u.id}>{u.name} ({u.serialNumber})</option>
                ))}
              </select>
            </div>

            <div className="form-group">
              <label className="form-label">Bonus Amount</label>
              <div className="input-wrapper">
                <span className="input-prefix">₹</span>
                <input 
                  type="number" 
                  className="form-input" 
                  value={dialogAmount}
                  onChange={(e) => setDialogAmount(e.target.value)}
                  placeholder="0.00"
                />
              </div>
            </div>

            <div className="form-group">
              <label className="form-label">Remarks (Optional)</label>
              <input 
                type="text"
                className="form-input" 
                value={dialogRemarks}
                onChange={(e) => setDialogRemarks(e.target.value)}
                placeholder="Enter remarks..."
              />
            </div>

            <div style={{ display: 'flex', gap: '12px', marginTop: '24px' }}>
              <button 
                onClick={() => setShowDialog(false)} 
                style={{ flex: 1, padding: '12px', borderRadius: '8px', border: '1px solid var(--border-color)', backgroundColor: 'transparent', color: 'var(--text-color)', cursor: 'pointer', fontWeight: 600 }}
              >
                Cancel
              </button>
              <button 
                onClick={handleSave} 
                disabled={isSaving}
                style={{ flex: 1, padding: '12px', borderRadius: '8px', border: 'none', backgroundColor: '#10b981', color: '#ffffff', cursor: 'pointer', fontWeight: 600 }}
              >
                {isSaving ? "Saving..." : "Give Bonus"}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default BonusManagement;
