import React from 'react';
import { useNavigate } from 'react-router-dom';
import SearchForm, { SearchFormValues } from './searchForm/SearchForm';
import styles from './HeroSection.module.css';

import heroBackground from '../../../../assets/landing/hero-bg.jpg';

export const HeroSection: React.FC = () => {
  const navigate = useNavigate();

  // Переход на страницу результатов поиска с параметрами в URL
  const handleSearch = (values: SearchFormValues) => {
    const params = new URLSearchParams({
      destination: values.destination.trim(),
      checkIn: values.checkIn,
      checkOut: values.checkOut,
      guests: String(values.guests),
    });
    navigate(`/search?${params.toString()}`);
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
