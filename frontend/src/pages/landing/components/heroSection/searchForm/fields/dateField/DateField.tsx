import React, { useRef } from 'react';
import styles from './DateField.module.css';

interface DateInputFieldProps {
  id: string;
  name: string;
  value: string; //формат "ДД.ММ.ГГГГ"
  onChange: (value: string) => void;
  onBlur: () => void;
  calendarIcon?: string;
  minDate?: string; //минимальная дата в формате "ДД.ММ.ГГГГ"
}

//преобразование "ДД.ММ.ГГГГ" -> "ГГГГ-ММ-ДД" 
const toIsoDate = (dateStr: string): string => {
  if (!/^\d{2}\.\d{2}\.\d{4}$/.test(dateStr)) return '';
  const [d, m, y] = dateStr.split('.');
  return `${y}-${m}-${d}`;
};

//преобразование "ГГГГ-ММ-ДД" -> "ДД.ММ.ГГГГ"
const fromIsoDate = (isoStr: string): string => {
  if (!/^\d{4}-\d{2}-\d{2}$/.test(isoStr)) return '';
  const [y, m, d] = isoStr.split('-');
  return `${d}.${m}.${y}`;
};

export const DateField: React.FC<DateInputFieldProps> = ({
  id,
  name,
  value,
  onChange,
  onBlur,
  calendarIcon,
  minDate,
}) => {
  const hiddenPickerRef = useRef<HTMLInputElement>(null);

  //обработка ручного ввода: цифры и точки с автоформатированием
  const handleTextInput = (e: React.ChangeEvent<HTMLInputElement>) => {
    const rawValue = e.target.value;

    if (rawValue.length < value.length) {
      onChange(rawValue);
      return;
    }

    //оставляем только цифры, максимум 8
    const digits = rawValue.replace(/\D/g, '').slice(0, 8);
    let formatted = digits;

    if (digits.length >= 5) {
      formatted = `${digits.slice(0, 2)}.${digits.slice(2, 4)}.${digits.slice(4)}`;
    } else if (digits.length >= 3) {
      formatted = `${digits.slice(0, 2)}.${digits.slice(2)}`;
    }

    onChange(formatted);
  };

  //выбор даты из всплывающего календаря
  const handlePickerChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.value) {
      onChange(fromIsoDate(e.target.value));
    }
  };

  //открытие календаря
  const openCalendar = () => {
    try {
      hiddenPickerRef.current?.showPicker();
    } catch {
      hiddenPickerRef.current?.focus();
    }
  };

  return (
    <div className={styles.wrapper}>
      {/* поле для ручного ввода текста */}
      <input
        type="text"
        id={id}
        name={name}
        value={value}
        onChange={handleTextInput}
        onBlur={onBlur}
        placeholder="ДД.ММ.ГГГГ"
        maxLength={10}
        className={styles.textInput}
      />

      {/* кнопка с иконкой для вызова календарика */}
      <button
        type="button"
        tabIndex={-1}
        onClick={openCalendar}
        className={styles.calendarButton}
        title="Открыть календарь"
      >
        {calendarIcon ? (
          <img src={calendarIcon} alt="" className={styles.icon} />
        ) : (
          <span className={styles.iconPlaceholder}>📅</span>
        )}
      </button>

      <input
        ref={hiddenPickerRef}
        type="date"
        tabIndex={-1}
        aria-hidden="true"
        value={toIsoDate(value)}
        min={minDate ? toIsoDate(minDate) : undefined}
        onChange={handlePickerChange}
        className={styles.hiddenPicker}
      />
    </div>
  );
};

export default DateField;