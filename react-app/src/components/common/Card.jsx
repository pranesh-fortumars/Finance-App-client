import React from 'react';
import './Common.css';

const Card = ({ title, subtitle, children, action, margin, padding }) => {
  return (
    <div 
      className="card-container" 
      style={{ 
        ...(margin ? { margin } : {}),
      }}
    >
      {(title || subtitle || action) && (
        <div className="card-header">
          <div style={{ flex: 1 }}>
            {title && <h3 className="card-title">{title}</h3>}
            {subtitle && <div className="card-subtitle">{subtitle}</div>}
          </div>
          {action && <div>{action}</div>}
        </div>
      )}
      <div 
        className="card-content"
        style={{
          ...(padding ? { padding } : {})
        }}
      >
        {children}
      </div>
    </div>
  );
};

export default Card;
