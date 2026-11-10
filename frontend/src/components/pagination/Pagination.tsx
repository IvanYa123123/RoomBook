import React from 'react';
import styles from './Pagination.module.css';
import { ArrowLeftIcon, ArrowRightIcon } from '../icons/Icons';

interface PaginationProps {
  page: number;
  totalPages: number;
  onChange: (page: number) => void;
}

/** Номера страниц с многоточиями: 1 2 3 … 5 */
const getPages = (page: number, total: number): (number | 'dots')[] => {
  if (total <= 5) return Array.from({ length: total }, (_, i) => i + 1);

  const pages = new Set<number>([1, total, page - 1, page, page + 1]);
  if (page <= 3) [2, 3].forEach((p) => pages.add(p));
  if (page >= total - 2) [total - 2, total - 1].forEach((p) => pages.add(p));

  const sorted = Array.from(pages)
    .filter((p) => p >= 1 && p <= total)
    .sort((a, b) => a - b);

  const result: (number | 'dots')[] = [];
  sorted.forEach((p, i) => {
    if (i > 0 && p - sorted[i - 1] > 1) result.push('dots');
    result.push(p);
  });
  return result;
};

export const Pagination: React.FC<PaginationProps> = ({ page, totalPages, onChange }) => {
  if (totalPages <= 1) return null;

  return (
    <nav className={styles.pagination} aria-label="Страницы результатов">
      {page > 1 && (
        <button type="button" className={styles.navButton} onClick={() => onChange(page - 1)}>
          <ArrowLeftIcon aria-hidden="true" /> Назад
        </button>
      )}

      {getPages(page, totalPages).map((p, i) =>
        p === 'dots' ? (
          <span key={`dots-${i}`} className={styles.dots}>
            …
          </span>
        ) : (
          <button
            key={p}
            type="button"
            className={`${styles.pageButton} ${p === page ? styles.active : ''}`}
            onClick={() => onChange(p)}
            aria-current={p === page ? 'page' : undefined}
          >
            {p}
          </button>
        ),
      )}

      {page < totalPages && (
        <button type="button" className={styles.navButton} onClick={() => onChange(page + 1)}>
          Вперед <ArrowRightIcon aria-hidden="true" />
        </button>
      )}
    </nav>
  );
};

export default Pagination;
