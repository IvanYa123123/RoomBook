import React from 'react';
import { Link } from 'react-router-dom';
import styles from './Footer.module.css'; 

import logo from './../../assets/logo.png';
import telegramIcon from './../../assets/telegram_grey.png';
import vkIcon from './../../assets/vk_grey.png';
import instagramIcon from './../../assets/inst_grey.png';

export const Footer: React.FC = () => {
  return (
    <footer className={styles.footer}>
      <div className={styles.container}>
        {/* Левая колонка: Логотип и копирайт */}
        <div className={styles.leftCol}>
          <Link to="/" className={styles.logo}>
            <img src={logo} alt="RoomBook" className={styles.logoImg} />
            <span className={styles.logoText}>RoomBook</span>
          </Link>
          <p className={styles.copyright}>
            © 2026 RoomBook. Все права защищены
          </p>
        </div>

        {/* Правая колонка: Навигация и соцсети */}
        <div className={styles.rightCol}>
          <nav className={styles.nav}>
            <Link to="/about" className={styles.navLink}>О нас</Link>
            <Link to="/partners" className={styles.navLink}>Партнерам</Link>
            <Link to="/support" className={styles.navLink}>Служба поддержки</Link>
            <Link to="/rules" className={styles.navLink}>Правила сервиса</Link>
          </nav>

          {/* соцсети */}
          <div className={styles.socials}>
            <a
              href="https://t.me"
              target="_blank"
              rel="noopener noreferrer"
              aria-label="Telegram"
              className={styles.socialLink}
            >
              <img src={telegramIcon} alt="Telegram" />
            </a>

            <a
              href="https://vk.com"
              target="_blank"
              rel="noopener noreferrer"
              aria-label="VKontakte"
              className={styles.socialLink}
            >
              <img src={vkIcon} alt="VK" />
            </a>

            <a
              href="https://instagram.com"
              target="_blank"
              rel="noopener noreferrer"
              aria-label="Instagram"
              className={styles.socialLink}
            >
              <img src={instagramIcon} alt="Instagram" />
            </a>
          </div>
        </div>
      </div>
    </footer>
  );
};

export default Footer;