import React, { useState, useEffect } from 'react';
import HotelCard from '../../../../components/hotelCard/HotelCard';
import { hotelsData } from '../../../../data/hotels_data';
import styles from './PopularHotelsSections.module.css';

export const PopularHotelsSection: React.FC = () => {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [visibleCards, setVisibleCards] = useState(3);

  // Определяем, сколько карточек помещается на экран (3, 2 или 1)
  useEffect(() => {
    const handleResize = () => {
      const width = window.innerWidth;
      if (width < 640) {
        setVisibleCards(1);
      } else if (width < 960) {
        setVisibleCards(2);
      } else {
        setVisibleCards(3);
      }
    };

    handleResize();
    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []);

  // Максимальный индекс смещения, чтобы не листать в пустоту
  const maxIndex = Math.max(0, hotelsData.length - visibleCards);

  // Корректируем индекс при смене разрешения экрана
  useEffect(() => {
    if (currentIndex > maxIndex) {
      setCurrentIndex(maxIndex);
    }
  }, [maxIndex, currentIndex]);

  const handlePrev = () => {
    setCurrentIndex((prev) => Math.max(0, prev - 1));
  };

  const handleNext = () => {
    setCurrentIndex((prev) => Math.min(maxIndex, prev + 1));
  };

  const isPrevDisabled = currentIndex === 0;
  const isNextDisabled = currentIndex >= maxIndex;

  // Расчет смещения ленты с учетом карточки и зазора gap (24px)
  const gap = 24;
  const slideOffset = `calc(-1 * ${currentIndex} * ((100% - ${(visibleCards - 1) * gap}px) / ${visibleCards} + ${gap}px))`;

  return (
    <section className={styles.section}>
      <div className={styles.container}>
        {/* Шапка со стрелками */}
        <div className={styles.header}>
          <h2 className={styles.title}>Популярные отели</h2>

          <div className={styles.controls}>
            <button
              type="button"
              className={`${styles.arrowButton} ${isPrevDisabled ? styles.disabled : ''}`}
              onClick={handlePrev}
              disabled={isPrevDisabled}
              aria-label="Назад"
            >
              ‹
            </button>
            <button
              type="button"
              className={`${styles.arrowButton} ${isNextDisabled ? styles.disabled : ''}`}
              onClick={handleNext}
              disabled={isNextDisabled}
              aria-label="Вперед"
            >
              ›
            </button>
          </div>
        </div>

        {/* Область просмотра (скрывает карточки за границами) */}
        <div className={styles.sliderViewport}>
          {/* Движущаяся лента с плавной анимацией transform */}
          <div
            className={styles.sliderTrack}
            style={{ transform: `translateX(${slideOffset})` }}
          >
            {hotelsData.map((hotel) => (
              <div key={hotel.id} className={styles.cardSlide}>
                <HotelCard
                  hotel={hotel}
                  isSquareImage={false}
                  onViewRooms={(id) => console.log('Клик по номеру отеля:', id)}
                />
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
};

export default PopularHotelsSection;