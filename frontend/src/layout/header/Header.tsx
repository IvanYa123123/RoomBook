import React from 'react';
import { Link } from 'react-router-dom';

import logo from '../../assets/logo.png';
import styles from './Header.module.css';

interface HeaderProps {
  onLoginClick?: () => void;
  onRegisterClick?: () => void;
}

export const Header: React.FC<HeaderProps> = ({
  onLoginClick,
  onRegisterClick,
}) => {
  return (
    <header className={styles.header}>
      <div className={styles.container}>
        {/* Логотип */}
        <Link to="/" className={styles.logo}>
          <img src={logo} alt="RoomBook" className={styles.logoIcon} />
          <span className={styles.logoText}>RoomBook</span>
        </Link>

        {/* Навигация / Действия */}
        <div className={styles.actions}>
          <button
            type="button"
            className={styles.loginBtn}
            onClick={onLoginClick}
          >
            Войти
          </button>
          <button
            type="button"
            className={styles.registerBtn}
            onClick={onRegisterClick}
          >
            Зарегистрироваться
          </button>
        </div>
      </div>
    </header>
  );
};

export default Header;