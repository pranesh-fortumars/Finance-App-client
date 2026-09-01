import React, { useState } from 'react';
import { useDataContext } from '../context/DataContext';
import { FirebaseService } from '../services/firebase';
import Card from '../components/common/Card';
import Button from '../components/common/Button';
import { Layers, PlusCircle, Activity, Archive } from 'lucide-react';
import './Pages.css';

const SchemeManagement = () => {
  const { schemeTypes, refreshData, isLoading } = useDataContext();
  const [showDialog, setShowDialog] = useState(false);
  
  const [name, setName] = useState('');
  const [description, setDescription] = useState('');
  const [amount, setAmount] = useState('');
  const [interestRate, setInterestRate] = useState('');
  const [duration, setDuration] = useState('365');
  const [isSaving, setIsSaving] = useState(false);

  const handleSave = async () => {
    if (!name || !amount || !interestRate) {
      alert("Please fill out all required fields.");
      return;
    }

    setIsSaving(true);
    try {
      const scheme = {
        id: Date.now().toString(),
        name,
        description,
        amount: Number(amount),
        interestRate: Number(interestRate),
        duration: Number(duration),
        frequency: 'monthly',
        status: 'active'
      };

      await FirebaseService.saveSchemeType(scheme);
      await refreshData();
      
      setShowDialog(false);
      setName('');
      setDescription('');
      setAmount('');
      setInterestRate('');
      setDuration('365');
      alert("Scheme created successfully!");
    } catch (error) {
      alert("Failed to create scheme: " + error.message);
    } finally {
      setIsSaving(false);
    }
  };

  if (isLoading) return <div className="screen-center">Loading Schemes...</div>;

  return (
    <div className="page-container">
      <div className="page-header" style={{ justifyContent: 'space-between' }}>
        <h2 style={{ margin: 0, display: 'flex', alignItems: 'center', gap: '8px' }}>
          <Layers size={24} color="#8b5cf6" /> Scheme Management
        </h2>
        <Button text="New Scheme" icon={PlusCircle} onClick={() => setShowDialog(true)} />
      </div>

      <div className="list-container">
        {schemeTypes.length === 0 ? (
          <div className="center-message">
            <Layers size={48} className="empty-icon" />
            <p>No schemes configured</p>
          </div>
        ) : (
          schemeTypes.map(scheme => (
            <Card key={scheme.id} margin="0 0 16px 0">
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
                <div>
                  <h3 style={{ margin: '0 0 4px 0', color: 'var(--text-color)' }}>{scheme.name}</h3>
                  <p style={{ margin: '0 0 12px 0', fontSize: '0.9rem', color: '#64748b' }}>{scheme.description}</p>
                </div>
                <div style={{ padding: '4px 12px', borderRadius: '12px', backgroundColor: scheme.status === 'active' || !scheme.status ? 'rgba(16, 185, 129, 0.1)' : 'rgba(100, 116, 139, 0.1)', color: scheme.status === 'active' || !scheme.status ? '#10b981' : '#64748b', fontSize: '0.8rem', fontWeight: 600, display: 'flex', alignItems: 'center', gap: '4px' }}>
                  {scheme.status === 'active' || !scheme.status ? <><Activity size={14} /> Active</> : <><Archive size={14} /> Archived</>}
                </div>
              </div>

              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: '12px', marginTop: '12px', paddingTop: '12px', borderTop: '1px solid var(--border-color, rgba(0,0,0,0.05))' }}>
                <div>
                  <div style={{ fontSize: '0.75rem', color: '#64748b', textTransform: 'uppercase', letterSpacing: '0.5px' }}>Target Amount</div>
                  <div style={{ fontWeight: 600, fontSize: '1.1rem' }}>₹{Number(scheme.amount).toFixed(2)}</div>
                </div>
                <div>
                  <div style={{ fontSize: '0.75rem', color: '#64748b', textTransform: 'uppercase', letterSpacing: '0.5px' }}>Interest Rate</div>
                  <div style={{ fontWeight: 600, fontSize: '1.1rem', color: '#3b82f6' }}>{scheme.interestRate}%</div>
                </div>
                <div>
                  <div style={{ fontSize: '0.75rem', color: '#64748b', textTransform: 'uppercase', letterSpacing: '0.5px' }}>Duration</div>
                  <div style={{ fontWeight: 600, fontSize: '1.1rem' }}>{scheme.duration} Days</div>
                </div>
              </div>
            </Card>
          ))
        )}
      </div>

      {showDialog && (
        <div style={{ position: 'fixed', inset: 0, backgroundColor: 'rgba(0,0,0,0.5)', zIndex: 100, display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '20px' }}>
          <div style={{ backgroundColor: 'var(--card-bg, #ffffff)', padding: '24px', borderRadius: '16px', width: '100%', maxWidth: '400px', maxHeight: '90vh', overflowY: 'auto' }}>
            <h3 style={{ margin: '0 0 16px 0' }}>Create New Scheme</h3>
            
            <div className="form-group">
              <label className="form-label">Scheme Name</label>
              <input 
                type="text" 
                className="form-input" 
                value={name}
                onChange={(e) => setName(e.target.value)}
                placeholder="e.g. Gold Saver"
              />
            </div>

            <div className="form-group">
              <label className="form-label">Description</label>
              <textarea 
                className="form-input" 
                rows={2}
                value={description}
                onChange={(e) => setDescription(e.target.value)}
                placeholder="Brief description..."
              />
            </div>

            <div className="form-group">
              <label className="form-label">Target Amount (₹)</label>
              <input 
                type="number" 
                className="form-input" 
                value={amount}
                onChange={(e) => setAmount(e.target.value)}
              />
            </div>

            <div className="form-group">
              <label className="form-label">Interest Rate (%)</label>
              <input 
                type="number" 
                className="form-input" 
                value={interestRate}
                onChange={(e) => setInterestRate(e.target.value)}
              />
            </div>

            <div className="form-group">
              <label className="form-label">Duration (Days)</label>
              <input 
                type="number" 
                className="form-input" 
                value={duration}
                onChange={(e) => setDuration(e.target.value)}
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
                style={{ flex: 1, padding: '12px', borderRadius: '8px', border: 'none', backgroundColor: '#8b5cf6', color: '#ffffff', cursor: 'pointer', fontWeight: 600 }}
              >
                {isSaving ? "Saving..." : "Create Scheme"}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default SchemeManagement;
