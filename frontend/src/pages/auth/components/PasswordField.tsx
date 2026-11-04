import React, { useState } from 'react';
import { IoEye, IoEyeOff } from 'react-icons/io5';
import styles from '../Auth.module.css';

export interface PasswordFieldProps {
  id?: string;
  name?: string;
  value?: string;
  onChange?: (e: React.ChangeEvent<HTMLInputElement>) => void;
  onBlur?: (e: React.FocusEvent<HTMLInputElement>) => void;
  placeholder?: string;
  hasError?: boolean;
  disabled?: boolean;
  autoComplete?: string;
  className?: string;
}

export const PasswordField: React.FC<PasswordFieldProps> = ({
  id,
  name,
  value,
  onChange,
  onBlur,
  placeholder,
  hasError = false,
  disabled = false,
  autoComplete = 'current-password',
  className = '',
}) => {
  const [isVisible, setIsVisible] = useState(false);

  const toggleVisibility = () => {
    setIsVisible((prev) => !prev);
  };

  const inputClasses = [
    styles.input,
    !isVisible ? styles.maskedInput : '',
    hasError ? styles.inputError : '',
    className,
  ]
    .filter(Boolean)
    .join(' ');

  return (
    <div className={styles.fieldWrapper}>
      <input
        id={id}
        name={name}
        type={isVisible ? 'text' : 'password'}
        value={value}
        onChange={onChange}
        onBlur={onBlur}
        placeholder={placeholder}
        disabled={disabled}
        autoComplete={autoComplete}
        className={inputClasses}
      />
      <button
        type="button"
        onClick={toggleVisibility}
        className={styles.toggleButton}
        aria-label={isVisible ? 'Скрыть пароль' : 'Показать пароль'}
        tabIndex={0}
      >
        {isVisible ? (
          (React.createElement(IoEye as any, { className: styles.icon, size: 22 }) as React.ReactElement)
        ) : (
          (React.createElement(IoEyeOff as any, { className: styles.icon, size: 22 }) as React.ReactElement)
        )}
      </button>
    </div>
  );
};

export default PasswordField;
