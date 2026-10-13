import React from 'react';
import SearchForm from './searchForm/SearchForm';
import styles from './HeroSection.module.css';

import heroBackground from '../../../../assets/landing/hero-bg.jpg';

export const HeroSection: React.FC = () => {
  const handleSearch = (values: unknown) => {
    console.log('Параметры поиска:', values);
  };

  return (
    <section
      className={styles.hero}
      style={{ backgroundImage: `url(${heroBackground})` }} 
    >
      <div className={styles.overlay} />

      <div className={styles.content}>
        <div className={styles.textBlock}>
          <h1 className={styles.title}>
            Найдите идеальное жилье за секунды
          </h1>
          <p className={styles.subtitle}>
            Быстрый сервис посуточного бронирования отелей и номеров
          </p>
        </div>

        <div className={styles.formContainer}>
          <SearchForm onSearch={handleSearch} />
        </div>
      </div>
    </section>
  );
};

export default HeroSection;