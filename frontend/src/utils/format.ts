/** Склонение существительного после числа: plural(5, ['отель', 'отеля', 'отелей']) */
export const plural = (n: number, forms: [string, string, string]): string => {
  const mod10 = n % 10;
  const mod100 = n % 100;
  if (mod10 === 1 && mod100 !== 11) return forms[0];
  if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) return forms[1];
  return forms[2];
};

export const formatPrice = (value: number): string => value.toLocaleString('ru-RU');

/** Оставляет только цифры и форматирует с пробелами: "15000" -> "15 000" */
export const formatPriceInput = (raw: string): string => {
  const digits = raw.replace(/\D/g, '').slice(0, 7);
  return digits ? Number(digits).toLocaleString('ru-RU') : '';
};

export const parsePriceInput = (value: string): number | undefined => {
  const digits = value.replace(/\D/g, '');
  return digits ? Number(digits) : undefined;
};
