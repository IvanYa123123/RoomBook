import React from 'react';
import { Room } from '../../../../data/hotels_data';
import { formatPrice } from '../../../../utils/format';
import styles from './RoomCard.module.css';
import { UserIcon } from '../../../../components/icons/Icons';

interface RoomCardProps {
  room: Room;
  onBook: (room: Room) => void;
}

export const RoomCard: React.FC<RoomCardProps> = ({ room, onBook }) => (
  <article className={styles.card}>
    <div className={styles.imageWrapper}>
      <img src={room.imageUrl} alt={room.name} className={styles.image} loading="lazy" />
    </div>

    <div className={styles.content}>
      <h3 className={styles.title}>{room.name}</h3>

      <div className={styles.metaRow}>
        <span className={styles.amenities}>{room.amenities.join(' · ')}</span>
        <span className={styles.capacity} title={`До ${room.capacity} гостей`}>
          <UserIcon aria-hidden="true" />x{room.capacity}
        </span>
      </div>

      <div className={styles.footerRow}>
        <div className={styles.price}>
          <span className={styles.priceValue}>{formatPrice(room.pricePerNight)} ₽</span>
          <span className={styles.priceSuffix}> / ночь</span>
        </div>
        <button type="button" className={styles.bookButton} onClick={() => onBook(room)}>
          Забронировать
        </button>
      </div>
    </div>
  </article>
);

export default RoomCard;
