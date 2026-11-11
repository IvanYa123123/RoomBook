import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import HotelCard from '../../../../components/hotelCard/HotelCard';
import { hotelsData } from '../../../../data/hotels_data';
import styles from './PopularHotelsSections.module.css';

export const PopularHotelsSection: React.FC = () => {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [visibleCards, setVisibleCards] = useState(3);

  const navigate = useNavigate();

  //определяем, сколько карточек помещается на экран (3, 2 или 1)
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

  //расчет смещения ленты 
  const gap = 24;
  const slideOffset = `calc(-1 * ${currentIndex} * ((100% - ${(visibleCards - 1) * gap}px) / ${visibleCards} + ${gap}px))`;

  return (
    <section className={styles.section}>
      <div className={styles.container}>

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

        {/* Область просмотра */}
        <div className={styles.sliderViewport}>
          <div
            className={styles.sliderTrack}
            style={{ transform: `translateX(${slideOffset})` }}
          >
            {hotelsData.map((hotel) => (
              <div key={hotel.id} className={styles.cardSlide}>
                <HotelCard
                  hotel={hotel}
                  isSquareImage={false}
                  onViewRooms={(id) => navigate(`/hotels/${id}`)}
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