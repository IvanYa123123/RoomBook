import React, { useEffect, useState } from 'react';
import { Link, useLocation, useNavigate, useParams } from 'react-router-dom';

import { getHotelById, Room } from '../../data/hotels_data';
import { plural } from '../../utils/format';
import pinIcon from '../../assets/icons/map-marker.png';

import Gallery from './components/gallery/Gallery';
import RoomCard from './components/roomCard/RoomCard';
import ReviewsSection from './components/reviews/ReviewsSection';
import styles from './HotelPage.module.css';
import { ArrowLeftIcon, StarIcon } from '../../components/icons/Icons';

function HotelPage() {
  const { id } = useParams();
  const navigate = useNavigate();
  const location = useLocation();
  const hotel = getHotelById(id);
  const [mainImage, setMainImage] = useState(hotel?.imageUrl);

  useEffect(() => {
    setMainImage(hotel?.imageUrl);
    window.scrollTo(0, 0);
  }, [hotel]);

  if (!hotel) {
    return (
      <main className={styles.notFound}>
        <h1>Отель не найден</h1>
        <p>Возможно, он был удалён или ссылка устарела.</p>
        <Link to="/search" className={styles.primaryLink}>
          Перейти к каталогу
        </Link>
      </main>
    );
  }

  // Назад к каталогу: если пришли со страницы поиска — возвращаемся с сохранёнными фильтрами
  const handleBack = (e: React.MouseEvent) => {
    if (window.history.state?.idx > 0) {
      e.preventDefault();
      navigate(-1);
    }
  };

  // Пользователь не авторизован -> форма регистрации (по сценарию из макета).
  // После появления авторизации здесь будет переход на форму бронирования.
  const handleBook = (room: Room) => {
    navigate('/reg', {
      state: { from: `${location.pathname}${location.search}`, hotelId: hotel.id, roomId: room.id },
    });
  };

  const images = [hotel.imageUrl, ...(hotel.gallery ?? [])];
  const reviewsWord = plural(hotel.reviewsCount, ['отзыв', 'отзыва', 'отзывов']);

  return (
    <main className={styles.page}>
      {/* Шапка отеля: галерея + описание */}
      <section className={styles.topSection}>
        <div className={styles.container}>
          <Link to="/search" className={styles.backLink} onClick={handleBack}>
            <ArrowLeftIcon aria-hidden="true" />
            Вернуться к каталогу
          </Link>

          <div className={styles.hero}>
            <Gallery
              images={images}
              mainImage={mainImage ?? hotel.imageUrl}
              alt={hotel.name}
              onSelect={setMainImage}
            />

            <div className={styles.info}>
              <h1 className={styles.name}>{hotel.name}</h1>

              <div className={styles.address}>
                <img src={pinIcon} alt="" className={styles.pin} />
                <span>{hotel.address}</span>
              </div>

              <div className={styles.rating}>
                <StarIcon className={styles.star} aria-hidden="true" />
                <strong>{hotel.rating.toFixed(1)}</strong>
                <span className={styles.muted}>
                  ({hotel.reviewsCount} {reviewsWord})
                </span>
              </div>

              <p className={styles.description}>{hotel.description}</p>
            </div>
          </div>
        </div>
      </section>

      {/* Доступные номера */}
      <section className={styles.section}>
        <div className={styles.container}>
          <h2 className={styles.sectionTitle}>Доступные номера</h2>
          <div className={styles.roomsGrid}>
            {hotel.rooms?.map((room) => (
              <RoomCard key={room.id} room={room} onBook={handleBook} />
            ))}
          </div>
        </div>
      </section>

      {/* Отзывы */}
      <section className={`${styles.section} ${styles.reviewsSection}`}>
        <div className={styles.container}>
          <h2 className={styles.sectionTitle}>Отзывы гостей</h2>
          <ReviewsSection
            rating={hotel.rating}
            reviewsCount={hotel.reviewsCount}
            reviews={hotel.reviews ?? []}
          />
        </div>
      </section>
    </main>
  );
}

export default HotelPage;
