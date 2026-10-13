import React from 'react';
import { useFormik } from 'formik';
import * as Yup from 'yup';

import SearchField from './fields/cityField/SearchField';
import DateInputField from './fields/dateField/DateField';
import styles from './SearchForm.module.css';

import locationIcon from '../../../../../assets/icons/map-marker.png';
import calendarIcon from '../../../../../assets/icons/calendar.png';
import userIcon from '../../../../../assets/icons/person.png';
import searchIcon from '../../../../../assets/icons/search_white.png';

export interface SearchFormValues {
  destination: string;
  checkIn: string;
  checkOut: string;
  guests: number;
}

interface SearchFormProps {
  onSearch?: (values: SearchFormValues) => void;
}

// Проверка реального существования календарной даты
const isValidCalendarDate = (dateStr?: string): boolean => {
  if (!dateStr || !/^\d{2}\.\d{2}\.\d{4}$/.test(dateStr)) return false;
  const [d, m, y] = dateStr.split('.').map(Number);
  if (m < 1 || m > 12 || y < 2000 || y > 2100) return false;

  const date = new Date(y, m - 1, d);
  return (
    date.getFullYear() === y &&
    date.getMonth() === m - 1 &&
    date.getDate() === d
  );
};

const parseDate = (dateStr: string): Date => {
  const [d, m, y] = dateStr.split('.').map(Number);
  return new Date(y, m - 1, d);
};

// Схема валидации
const validationSchema = Yup.object({
  destination: Yup.string()
    .trim()
    .min(2, 'Минимум 2 символа')
    .required('Укажите город или отель'),
  checkIn: Yup.string()
    .required('Укажите дату заезда')
    .test('is-valid-date', 'Неверная дата (ДД.ММ.ГГГГ)', isValidCalendarDate),
  checkOut: Yup.string()
    .required('Укажите дату выезда')
    .test('is-valid-date', 'Неверная дата (ДД.ММ.ГГГГ)', isValidCalendarDate)
    .test('is-after-checkin', 'Выезд позже заезда', function (val) {
      const { checkIn } = this.parent;
      if (!isValidCalendarDate(val) || !isValidCalendarDate(checkIn)) return true;
      return parseDate(val!) > parseDate(checkIn);
    }),
  guests: Yup.number()
    .min(1, 'Минимум 1')
    .max(20, 'Максимум 20')
    .required('Укажите гостей'),
});

export const SearchForm: React.FC<SearchFormProps> = ({ onSearch }) => {
  const formik = useFormik<SearchFormValues>({
    initialValues: {
      destination: 'Россия, Севастополь',
      checkIn: '08.10.2026',
      checkOut: '16.10.2026',
      guests: 2,
    },
    validationSchema,
    onSubmit: (values) => {
      onSearch?.(values);
    },
  });

  return (
    <form className={styles.form} onSubmit={formik.handleSubmit} noValidate>
      {/* 1. Иконка локации слева */}
      <div className={styles.locationBadge}>
        <img src={locationIcon} alt="Локация" className={styles.badgeIcon} />
      </div>

      {/* 2. Направление */}
      <SearchField
        label="Куда вы едете?"
        className={styles.destinationField}
        error={formik.errors.destination}
        touched={formik.touched.destination}
      >
        <input
          type="text"
          id="destination"
          name="destination"
          value={formik.values.destination}
          onChange={formik.handleChange}
          onBlur={formik.handleBlur}
        />
      </SearchField>

      <div className={styles.divider} aria-hidden="true" />

      {/* 3. Заезд (ручной ввод + календарь) */}
      <SearchField
        label="Заезд"
        labelIcon={calendarIcon}
        className={styles.dateField}
        error={formik.errors.checkIn}
        touched={formik.touched.checkIn}
      >
        <DateInputField
          id="checkIn"
          name="checkIn"
          value={formik.values.checkIn}
          onChange={(val) => formik.setFieldValue('checkIn', val)}
          onBlur={() => formik.setFieldTouched('checkIn', true)}
          calendarIcon={calendarIcon}
        />
      </SearchField>

      {/* 4. Выезд (ручной ввод + календарь) */}
      <SearchField
        label="Выезд"
        labelIcon={calendarIcon}
        className={styles.dateField}
        error={formik.errors.checkOut}
        touched={formik.touched.checkOut}
      >
        <DateInputField
          id="checkOut"
          name="checkOut"
          value={formik.values.checkOut}
          minDate={formik.values.checkIn}
          onChange={(val) => formik.setFieldValue('checkOut', val)}
          onBlur={() => formik.setFieldTouched('checkOut', true)}
          calendarIcon={calendarIcon}
        />
      </SearchField>

      <div className={styles.divider} aria-hidden="true" />

      {/* 5. Гости */}
      <SearchField
        label="Гости"
        labelIcon={userIcon}
        className={styles.guestsField}
        error={formik.errors.guests}
        touched={formik.touched.guests}
      >
        <input
          type="number"
          id="guests"
          name="guests"
          min={1}
          max={20}
          value={formik.values.guests}
          onChange={formik.handleChange}
          onBlur={formik.handleBlur}
          style={{ textAlign: 'center' }}
        />
      </SearchField>

      {/* 6. Кнопка "Найти" */}
      <button type="submit" className={styles.searchButton}>
        <img src={searchIcon} alt="" className={styles.searchIcon} />
        <span>Найти</span>
      </button>
    </form>
  );
};

export default SearchForm;