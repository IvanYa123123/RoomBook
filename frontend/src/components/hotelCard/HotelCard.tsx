import React from 'react';
import { Hotel } from '../../data/hotels_data';
import styles from './HotelCard.module.css';

// === ИМПОРТ ИКОНОК (ЕСЛИ ЕСТЬ ФАЙЛЫ) ===
// import pinIcon from '../../assets/icons/pin.png';
// import starIcon from '../../assets/icons/star.png';

interface HotelCardProps {
  hotel: Hotel;
  isSquareImage?: boolean; // true = 1:1, false = 16:10 (как на макете лендинга)
  onViewRooms?: (hotelId: string | number) => void;
}

export const HotelCard: React.FC<HotelCardProps> = ({
  hotel,
  isSquareImage = false,
  onViewRooms,
}) => {
  return (
    <article className={styles.card}>
      {/* 1. Блок изображения с бейджем рейтинга */}
      <div
        className={`${styles.imageWrapper} ${
          isSquareImage ? styles.squareImage : styles.landscapeImage
        }`}
      >
        <img
          src={hotel.imageUrl}
          alt={hotel.name}
          className={styles.image}
          loading="lazy"
        />

        {/* Бейдж рейтинга в левом нижнем углу фото */}
        <div className={styles.ratingBadge}>
          {/* Звездочка (SVG или картинка) */}
          <span className={styles.starIcon}>★</span>
          {/* Если есть star.png: <img src={starIcon} alt="" className={styles.starImg} /> */}
          <span className={styles.ratingScore}>{hotel.rating.toFixed(1)}</span>
          <span className={styles.reviewsCount}>({hotel.reviewsCount} отзыва)</span>
        </div>
      </div>

      {/* 2. Контентная часть */}
      <div className={styles.content}>
        <h3 className={styles.title} title={hotel.name}>
          {hotel.name}
        </h3>

        {/* Адрес с гео-меткой */}
        <div className={styles.addressRow}>
          {/* Гео-метка */}
          <span className={styles.pinIcon}>📍</span>
          {/* Если есть pin.png: <img src={pinIcon} alt="" className={styles.pinImg} /> */}
          <span className={styles.addressText}>{hotel.address}</span>
        </div>

        {/* Нижняя строка: Стоимость и Кнопка */}
        <div className={styles.footerRow}>
          <div className={styles.priceBlock}>
            <span className={styles.pricePrefix}>от </span>
            <span className={styles.priceValue}>
              {hotel.pricePerNight.toLocaleString('ru-RU')} ₽
            </span>
            <span className={styles.priceSuffix}> / ночь</span>
          </div>

          <button
            type="button"
            className={styles.viewButton}
            onClick={() => onViewRooms?.(hotel.id)}
          >
            Посмотреть номера
          </button>
        </div>
      </div>
    </article>
  );
};

export default HotelCard;