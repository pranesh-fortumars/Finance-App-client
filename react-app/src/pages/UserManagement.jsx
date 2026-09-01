import React, { useState, useEffect } from 'react';
import { FirebaseService } from '../services/firebase';
import Card from '../components/common/Card';
import Button from '../components/common/Button';
import { Search, UserPlus, MapPin, Calendar, Users } from 'lucide-react';
import './Pages.css';

const UserManagement = () => {
  const [users, setUsers] = useState([]);
  const [filteredUsers, setFilteredUsers] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [searchQuery, setSearchQuery] = useState('');

  const loadUsers = async () => {
    setIsLoading(true);
    try {
      const data = await FirebaseService.getUsers();
      setUsers(data);
      setFilteredUsers(data);
    } catch (error) {
      console.error("Failed to fetch users", error);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    loadUsers();
  }, []);

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
          onClick={() => alert("Add User Form pending (just like Flutter placeholder)")} 
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
                  <span>Joined {new Date(user.createdAt).toLocaleDateString()}</span>
                </div>
              </div>
            </Card>
          ))
        )}
      </div>
    </div>
  );
};

export default UserManagement;
