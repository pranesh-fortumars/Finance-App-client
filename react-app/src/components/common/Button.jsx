import React from 'react';
import './Common.css';

const Button = ({
  text,
  onClick,
  variant = 'primary',
  size = 'medium',
  isLoading = false,
  icon: Icon,
  width,
  height,
  disabled = false,
  style = {}
}) => {
  const baseClass = `btn btn-${variant} btn-${size}`;
  
  return (
    <button
      className={baseClass}
      onClick={onClick}
      disabled={disabled || isLoading}
      style={{
        ...(width ? { width } : {}),
        ...(height ? { height } : {}),
        ...style
      }}
    >
      {isLoading && <div className="spinner" />}
      {!isLoading && Icon && (
        <span className="btn-icon">
          <Icon size={size === 'small' ? 16 : size === 'medium' ? 20 : 24} />
        </span>
      )}
      {text && <span>{text}</span>}
    </button>
  );
};

export default Button;
