import React, { useState } from 'react';
import { getRatingDistribution, Review } from '../../../../data/hotels_data';
import { plural } from '../../../../utils/format';
import styles from './ReviewsSection.module.css';
import { StarIcon } from '../../../../components/icons/Icons';

const INITIAL_COUNT = 3;

interface ReviewsSectionProps {
  rating: number;
  reviewsCount: number;
  reviews: Review[];
}

const Stars: React.FC<{ value: number }> = ({ value }) => (
  <div className={styles.stars} aria-label={`Оценка ${value} из 5`}>
    {[1, 2, 3, 4, 5].map((n) => (
      <StarIcon key={n} className={n <= value ? styles.starFilled : styles.starEmpty} />
    ))}
  </div>
);

export const ReviewsSection: React.FC<ReviewsSectionProps> = ({ rating, reviewsCount, reviews }) => {
  const [visibleCount, setVisibleCount] = useState(INITIAL_COUNT);
  const distribution = getRatingDistribution(rating);
  const visible = reviews.slice(0, visibleCount);
  const hasMore = visibleCount < reviews.length;

  return (
    <div className={styles.layout}>
      {/* Сводка рейтинга */}
      <aside className={styles.summary}>
        <div className={styles.score}>
          <StarIcon className={styles.bigStar} aria-hidden="true" />
          <span>{rating.toFixed(1)}</span>
        </div>
        <div className={styles.count}>
          ({reviewsCount} {plural(reviewsCount, ['отзыв', 'отзыва', 'отзывов'])})
        </div>

        <ul className={styles.bars}>
          {distribution.map((share, i) => (
            <li key={i} className={styles.barRow}>
              <span className={styles.barLabel}>{5 - i}</span>
              <span className={styles.barTrack}>
                <span className={styles.barFill} style={{ width: `${share * 100}%` }} />
              </span>
            </li>
          ))}
        </ul>
      </aside>

      {/* Список отзывов */}
      <div className={styles.listWrapper}>
        <ul className={styles.list}>
          {visible.map((review) => (
            <li key={review.id} className={styles.review}>
              <div className={styles.reviewHeader}>
                <div>
                  <div className={styles.author}>{review.author}</div>
                  <div className={styles.date}>{review.date}</div>
                </div>
                <Stars value={review.rating} />
              </div>
              <p className={styles.text}>{review.text}</p>
            </li>
          ))}
        </ul>

        {reviews.length > INITIAL_COUNT && (
          <button
            type="button"
            className={styles.moreButton}
            onClick={() => setVisibleCount(hasMore ? reviews.length : INITIAL_COUNT)}
          >
            {hasMore ? 'Показать еще' : 'Свернуть'}
          </button>
        )}
      </div>
    </div>
  );
};

export default ReviewsSection;
