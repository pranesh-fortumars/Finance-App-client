import React, { useState, useEffect } from 'react';
import { useDataContext } from '../context/DataContext';
import { FirebaseService } from '../services/firebase';
import Card from '../components/common/Card';
import Button from '../components/common/Button';
import { Search, UserPlus, MapPin, Calendar, Users } from 'lucide-react';
import './Pages.css';

const UserManagement = () => {
  const { users, isLoading, refreshData } = useDataContext();
  const [filteredUsers, setFilteredUsers] = useState([]);
  const [searchQuery, setSearchQuery] = useState('');
  
  // Dialog State
  const [showDialog, setShowDialog] = useState(false);
  const [isSaving, setIsSaving] = useState(false);
  const [newUser, setNewUser] = useState({
    name: '',
    mobileNumber: '',
    city: '',
    state: ''
  });

  useEffect(() => {
    setFilteredUsers(users);
  }, [users]);

  const handleSearch = (e) => {
    const query = e.target.value.toLowerCase();
    setSearchQuery(query);
    
    if (!query) {
      setFilteredUsers(users);
      return;
    }

    const filtered = users.filter(user => 
      (user.name && user.name.toLowerCase().includes(query)) ||
      (user.mobileNumber && user.mobileNumber.includes(query)) ||
      (user.serialNumber && user.serialNumber.toLowerCase().includes(query)) ||
      (user.permanentAddress?.city && user.permanentAddress.city.toLowerCase().includes(query))
    );
    setFilteredUsers(filtered);
  };

  const handleAddUser = async () => {
    if (!newUser.name || !newUser.mobileNumber) {
      alert("Name and mobile number are required!");
      return;
    }
    
    setIsSaving(true);
    try {
      const serialNumber = await FirebaseService.generateNextSerialNumber();
      const userObj = {
        id: Date.now().toString(),
        name: newUser.name,
        mobileNumber: newUser.mobileNumber,
        serialNumber,
        createdAt: new Date().toISOString(),
        status: 'active',
        permanentAddress: {
          city: newUser.city || 'Unknown',
          state: newUser.state || 'Unknown'
        }
      };

      await FirebaseService.saveUser(userObj);
      await refreshData();
      
      setShowDialog(false);
      setNewUser({ name: '', mobileNumber: '', city: '', state: '' });
      alert(`User ${userObj.name} added successfully with ID ${userObj.serialNumber}!`);
    } catch (e) {
      alert("Error adding user: " + e.message);
    } finally {
      setIsSaving(false);
    }
  };

  return (
    <div className="page-container">
      {/* Header */}
      <div className="page-header">
        <div className="search-container">
          <Search size={20} className="search-icon" />
          <input 
            type="text" 
            placeholder="Search users by name, mobile, or city..."
            value={searchQuery}
            onChange={handleSearch}
            className="search-input"
          />
        </div>
        <Button 
          text="Add User" 
          icon={UserPlus} 
          onClick={() => setShowDialog(true)} 
        />
      </div>

      {/* Users List */}
      <div className="list-container">
        {isLoading ? (
          <div className="center-message">Loading users...</div>
        ) : filteredUsers.length === 0 ? (
          <div className="center-message empty-state">
            <Users size={48} className="empty-icon" />
            <p>{searchQuery ? 'No users match your search' : 'No users found'}</p>
          </div>
        ) : (
          filteredUsers.map(user => (
            <Card key={user.id} margin="0 0 12px 0">
              <div className="user-card-layout">
                {/* Avatar */}
                <div className="user-avatar">
                  {user.name ? user.name.charAt(0).toUpperCase() : 'U'}
                </div>
                
                {/* Details */}
                <div className="user-details">
                  <h4>{user.name}</h4>
                  <p className="subtitle">{user.mobileNumber}</p>
                  <p className="subtitle small">ID: {user.serialNumber}</p>
                </div>
              </div>

              <div className="user-meta">
                <div className="meta-item">
                  <MapPin size={16} />
                  <span>
                    {user.permanentAddress?.city || 'Unknown'}, {user.permanentAddress?.state || ''}
                  </span>
                </div>
                <div className="meta-item">
                  <Calendar size={16} />
                  <span>Joined {new Date(user.createdAt?.seconds ? user.createdAt.seconds * 1000 : user.createdAt).toLocaleDateString()}</span>
                </div>
              </div>
            </Card>
          ))
        )}
      </div>

      {/* Add User Dialog */}
      {showDialog && (
        <div style={{ position: 'fixed', inset: 0, backgroundColor: 'rgba(0,0,0,0.5)', zIndex: 100, display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '20px' }}>
          <div style={{ backgroundColor: 'var(--card-bg, #ffffff)', padding: '24px', borderRadius: '16px', width: '100%', maxWidth: '400px' }}>
            <h3 style={{ margin: '0 0 16px 0' }}>Add New User</h3>
            
            <div className="form-group">
              <label className="form-label">Full Name</label>
              <input 
                type="text" 
                className="form-input" 
                value={newUser.name}
                onChange={(e) => setNewUser({...newUser, name: e.target.value})}
                placeholder="e.g. John Doe"
              />
            </div>

            <div className="form-group">
              <label className="form-label">Mobile Number</label>
              <input 
                type="tel" 
                className="form-input" 
                value={newUser.mobileNumber}
                onChange={(e) => setNewUser({...newUser, mobileNumber: e.target.value})}
                placeholder="+91 98765 43210"
              />
            </div>

            <div style={{ display: 'flex', gap: '12px' }}>
              <div className="form-group" style={{ flex: 1 }}>
                <label className="form-label">City</label>
                <input 
                  type="text" 
                  className="form-input" 
                  value={newUser.city}
                  onChange={(e) => setNewUser({...newUser, city: e.target.value})}
                  placeholder="City"
                />
              </div>
              <div className="form-group" style={{ flex: 1 }}>
                <label className="form-label">State</label>
                <input 
                  type="text" 
                  className="form-input" 
                  value={newUser.state}
                  onChange={(e) => setNewUser({...newUser, state: e.target.value})}
                  placeholder="State"
                />
              </div>
            </div>

            <div style={{ display: 'flex', gap: '12px', marginTop: '24px' }}>
              <button 
                onClick={() => setShowDialog(false)} 
                style={{ flex: 1, padding: '12px', borderRadius: '8px', border: '1px solid var(--border-color)', backgroundColor: 'transparent', color: 'var(--text-color)', cursor: 'pointer', fontWeight: 600 }}
              >
                Cancel
              </button>
              <button 
                onClick={handleAddUser} 
                disabled={isSaving}
                style={{ flex: 1, padding: '12px', borderRadius: '8px', border: 'none', backgroundColor: '#3b82f6', color: '#ffffff', cursor: 'pointer', fontWeight: 600 }}
              >
                {isSaving ? "Saving..." : "Add User"}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default UserManagement;
