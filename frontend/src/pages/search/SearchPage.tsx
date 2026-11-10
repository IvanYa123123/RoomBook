import React, { useEffect, useMemo, useState } from 'react';
import { Link, useNavigate, useSearchParams } from 'react-router-dom';

import HotelCard from '../../components/hotelCard/HotelCard';
import Pagination from '../../components/pagination/Pagination';
import { hotelsData } from '../../data/hotels_data';
import { formatPriceInput, parsePriceInput, plural } from '../../utils/format';
import styles from './SearchPage.module.css';
import { ArrowLeftIcon, CloseIcon } from '../../components/icons/Icons';

const PAGE_SIZE = 6;
const DEFAULT_MIN_PRICE = 2500;
const DEFAULT_MAX_PRICE = 15000;

/** Параметры бронирования, которые прокидываются дальше на страницу отеля */
const BOOKING_PARAMS = ['checkIn', 'checkOut', 'guests'] as const;

/** "Россия, Севастополь" -> "севастополь" (ищем по последней части) */
const normalizeQuery = (destination: string): string => {
  const parts = destination.split(',').map((p) => p.trim()).filter(Boolean);
  return (parts[parts.length - 1] ?? '').toLowerCase();
};

function SearchPage() {
  const navigate = useNavigate();
  const [searchParams, setSearchParams] = useSearchParams();

  const destination = searchParams.get('destination') ?? '';
  const checkIn = searchParams.get('checkIn') ?? '';
  const checkOut = searchParams.get('checkOut') ?? '';
  const guests = Number(searchParams.get('guests')) || 0;
  const minPrice = Number(searchParams.get('minPrice')) || DEFAULT_MIN_PRICE;
  const maxPrice = Number(searchParams.get('maxPrice')) || DEFAULT_MAX_PRICE;
  const page = Math.max(1, Number(searchParams.get('page')) || 1);

  // Локальное состояние полей фильтра (применяется по кнопке)
  const [minInput, setMinInput] = useState(formatPriceInput(String(minPrice)));
  const [maxInput, setMaxInput] = useState(formatPriceInput(String(maxPrice)));

  useEffect(() => {
    setMinInput(formatPriceInput(String(minPrice)));
    setMaxInput(formatPriceInput(String(maxPrice)));
  }, [minPrice, maxPrice]);

  const results = useMemo(() => {
    const query = normalizeQuery(destination);
    return hotelsData.filter((hotel) => {
      const haystack = `${hotel.city} ${hotel.name} ${hotel.address}`.toLowerCase();
      const matchesQuery = !query || haystack.includes(query);
      const matchesPrice = hotel.pricePerNight >= minPrice && hotel.pricePerNight <= maxPrice;
      return matchesQuery && matchesPrice;
    });
  }, [destination, minPrice, maxPrice]);

  const totalPages = Math.max(1, Math.ceil(results.length / PAGE_SIZE));
  const currentPage = Math.min(page, totalPages);
  const pageItems = results.slice((currentPage - 1) * PAGE_SIZE, currentPage * PAGE_SIZE);

  const updateParams = (patch: Record<string, string | null>) => {
    const next = new URLSearchParams(searchParams);
    Object.entries(patch).forEach(([key, value]) => {
      if (value === null || value === '') next.delete(key);
      else next.set(key, value);
    });
    setSearchParams(next);
  };

  const handleApplyPrice = (e: React.FormEvent) => {
    e.preventDefault();
    let min = parsePriceInput(minInput) ?? DEFAULT_MIN_PRICE;
    let max = parsePriceInput(maxInput) ?? DEFAULT_MAX_PRICE;
    if (min > max) [min, max] = [max, min];
    updateParams({ minPrice: String(min), maxPrice: String(max), page: null });
  };

  const handlePageChange = (nextPage: number) => {
    updateParams({ page: nextPage === 1 ? null : String(nextPage) });
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const handleViewRooms = (hotelId: string | number) => {
    const params = new URLSearchParams();
    BOOKING_PARAMS.forEach((key) => {
      const value = searchParams.get(key);
      if (value) params.set(key, value);
    });
    const query = params.toString();
    navigate(`/hotels/${hotelId}${query ? `?${query}` : ''}`);
  };

  const summaryParts = [
    destination,
    checkIn && checkOut ? `${checkIn} - ${checkOut}` : '',
    guests ? `${guests} ${plural(guests, ['гость', 'гостя', 'гостей'])}` : '',
  ].filter(Boolean);

  return (
    <main className={styles.page}>
      {/* Панель с параметрами поиска */}
      <div className={styles.searchBar}>
        <div className={`${styles.container} ${styles.searchBarInner}`}>
          <Link to="/" className={styles.backLink}>
            <ArrowLeftIcon aria-hidden="true" />
            Вернуться на главную
          </Link>

          {summaryParts.length > 0 && (
            <div className={styles.summaryChip}>
              <span className={styles.summaryText}>{summaryParts.join(' · ')}</span>
              <button
                type="button"
                className={styles.clearButton}
                onClick={() => navigate('/search')}
                aria-label="Сбросить параметры поиска"
                title="Сбросить параметры поиска"
              >
                <CloseIcon />
              </button>
            </div>
          )}
        </div>
      </div>

      <section className={styles.container}>
        <div className={styles.toolbar}>
          <h1 className={styles.title}>
            Найдено {results.length} {plural(results.length, ['отель', 'отеля', 'отелей'])}
          </h1>

          <form className={styles.priceFilter} onSubmit={handleApplyPrice}>
            <span className={styles.priceLabel}>Цена за ночь:</span>
            <label className={styles.priceField}>
              <span>от</span>
              <input
                type="text"
                inputMode="numeric"
                value={minInput}
                onChange={(e) => setMinInput(formatPriceInput(e.target.value))}
                aria-label="Минимальная цена"
              />
            </label>
            <label className={styles.priceField}>
              <span>до</span>
              <input
                type="text"
                inputMode="numeric"
                value={maxInput}
                onChange={(e) => setMaxInput(formatPriceInput(e.target.value))}
                aria-label="Максимальная цена"
              />
            </label>
            <span className={styles.currency}>₽</span>
            <button type="submit" className={styles.applyButton}>
              Применить
            </button>
          </form>
        </div>

        {pageItems.length > 0 ? (
          <div className={styles.grid}>
            {pageItems.map((hotel) => (
              <HotelCard
                key={hotel.id}
                hotel={hotel}
                isSquareImage
                onViewRooms={handleViewRooms}
              />
            ))}
          </div>
        ) : (
          <div className={styles.empty}>
            <h2>Ничего не нашлось</h2>
            <p>Попробуйте изменить город или расширить диапазон цен.</p>
            <button type="button" className={styles.applyButton} onClick={() => navigate('/search')}>
              Сбросить фильтры
            </button>
          </div>
        )}

        <div className={styles.paginationWrapper}>
          <Pagination page={currentPage} totalPages={totalPages} onChange={handlePageChange} />
        </div>
      </section>
    </main>
  );
}

export default SearchPage;
