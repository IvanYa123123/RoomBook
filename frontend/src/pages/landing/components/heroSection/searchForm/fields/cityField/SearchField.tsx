import React from 'react';
import styles from './SearchField.module.css';

interface SearchFieldProps {
  label: string;
  labelIcon?: string;
  labelIconAlt?: string;
  children: React.ReactNode;
  className?: string;
  error?: string;
  touched?: boolean;
}

export const SearchField: React.FC<SearchFieldProps> = ({
  label,
  labelIcon,
  labelIconAlt = '',
  children,
  className = '',
  error,
  touched,
}) => {
  const isInvalid = Boolean(touched && error);

  return (
    <div className={`${styles.fieldWrapper} ${className}`}>
      {/* Метка с иконкой */}
      <div className={styles.labelRow}>
        {labelIcon && (
          <img src={labelIcon} alt={labelIconAlt} className={styles.labelIcon} />
        )}
        <span className={styles.label}>{label}</span>
      </div>

      {/* Обертка поля: слушает активность вложенного инпута через :focus-within */}
      <div className={`${styles.inputContainer} ${isInvalid ? styles.hasError : ''}`}>
        {children}
      </div>

      {/* Текст ошибки */}
      {isInvalid && (
        <span className={styles.errorMessage}>{error}</span>
      )}
    </div>
  );
};

export default SearchField;