// === ИМПОРТ ФОТОГРАФИЙ ОТЕЛЕЙ ===
import hotel1Img from '../assets/hotels/hotel1.jpg';
import hotel2Img from '../assets/hotels/hotel2.jpg';
import hotel3Img from '../assets/hotels/hotel3.jpg';
import hotel4Img from '../assets/hotels/hotel4.jpg';
import hotel5Img from '../assets/hotels/hotel5.jpg';
import hotel6Img from '../assets/hotels/hotel6.jpg';
import hotel7Img from '../assets/hotels/hotel7.jpg';
import hotel8Img from '../assets/hotels/hotel8.jpg';
import hotel9Img from '../assets/hotels/hotel9.jpg';
import hotel10Img from '../assets/hotels/hotel10.jpg';
import hotel11Img from '../assets/hotels/hotel11.jpg';
import hotel12Img from '../assets/hotels/hotel12.jpg';

// === ФОТОГРАФИИ НОМЕРОВ ===
import room1Img from '../assets/rooms/room1.jpg';
import room2Img from '../assets/rooms/room2.jpg';
import room3Img from '../assets/rooms/room3.jpg';
import room4Img from '../assets/rooms/room4.jpg';
import room5Img from '../assets/rooms/room5.jpg';
import room6Img from '../assets/rooms/room6.jpg';

export interface Room {
  id: string;
  name: string;
  amenities: string[];
  capacity: number;
  pricePerNight: number;
  imageUrl: string;
}

export interface Review {
  id: string;
  author: string;
  date: string;
  rating: number;
  text: string;
}

export interface Hotel {
  id: string | number;
  name: string;
  city: string;
  address: string;
  rating: number;
  reviewsCount: number;
  pricePerNight: number;
  imageUrl: string;
  /** Показывать в блоке «Популярные отели» на лендинге */
  isPopular?: boolean;
  description?: string;
  /** Дополнительные фото для галереи (главное фото — imageUrl) */
  gallery?: string[];
  rooms?: Room[];
  reviews?: Review[];
}

const roomImages = [room1Img, room2Img, room3Img, room4Img, room5Img, room6Img];
const hotelImages = [
  hotel1Img, hotel2Img, hotel3Img, hotel4Img, hotel5Img, hotel6Img,
  hotel7Img, hotel8Img, hotel9Img, hotel10Img, hotel11Img, hotel12Img,
];

const BASE_AMENITIES = ['Wi-Fi', 'Кондиционер', 'Телевизор'];

/** Набор номеров по умолчанию — цены считаются от минимальной цены отеля */
const makeRooms = (hotelId: string, basePrice: number, seed: number): Room[] => [
  {
    id: `${hotelId}-r1`,
    name: 'Стандартный 2-х местный номер',
    amenities: [...BASE_AMENITIES, 'Балкон'],
    capacity: 2,
    pricePerNight: basePrice,
    imageUrl: roomImages[seed % 6],
  },
  {
    id: `${hotelId}-r2`,
    name: 'Семейный люкс',
    amenities: [...BASE_AMENITIES, 'Балкон'],
    capacity: 4,
    pricePerNight: Math.round((basePrice * 1.45) / 100) * 100,
    imageUrl: roomImages[(seed + 1) % 6],
  },
  {
    id: `${hotelId}-r3`,
    name: 'Улучшенный номер с видом на море',
    amenities: [...BASE_AMENITIES, 'Мини-бар', 'Вид на море'],
    capacity: 2,
    pricePerNight: Math.round((basePrice * 1.25) / 100) * 100,
    imageUrl: roomImages[(seed + 2) % 6],
  },
];

const DEFAULT_REVIEWS: Review[] = [
  {
    id: 'rv1',
    author: 'Мария',
    date: '12 октября 2026',
    rating: 5,
    text: 'Потрясающий отель! Расположение идеальное, номер чистый и просторный. Завтрак превосходный.',
  },
  {
    id: 'rv2',
    author: 'Алексей',
    date: '4 апреля 2026',
    rating: 5,
    text: 'Все супер! Сервис на уровне, вернемся снова!',
  },
  {
    id: 'rv3',
    author: 'Елена',
    date: '5 сентября 2026',
    rating: 4,
    text: 'Красиво, но немного шумно. В остальном - отлично!',
  },
  {
    id: 'rv4',
    author: 'Дмитрий',
    date: '21 августа 2026',
    rating: 5,
    text: 'Отличное соотношение цены и качества. Персонал очень вежливый, заселили раньше времени.',
  },
  {
    id: 'rv5',
    author: 'Ольга',
    date: '2 июля 2026',
    rating: 4,
    text: 'Хороший отель, до моря пять минут пешком. Хотелось бы побольше вариантов на завтрак.',
  },
  {
    id: 'rv6',
    author: 'Игорь',
    date: '15 июня 2026',
    rating: 5,
    text: 'Были с детьми — всем понравилось. Большая территория, бассейн, детская площадка.',
  },
];

const makeGallery = (seed: number): string[] => [
  hotelImages[(seed + 3) % 12],
  roomImages[(seed + 3) % 6],
  hotelImages[(seed + 7) % 12],
  roomImages[(seed + 4) % 6],
];

const defaultDescription = (name: string, city: string) =>
  `${name} — уютное место для отдыха в городе ${city}. Комфортабельные номера, ` +
  'внимательный персонал и удобное расположение рядом с главными достопримечательностями. ' +
  'Для гостей работает ресторан, бесплатный Wi-Fi и круглосуточная стойка регистрации.';

type HotelSeed = Omit<Hotel, 'rooms' | 'reviews' | 'gallery' | 'description'> &
  Partial<Pick<Hotel, 'rooms' | 'reviews' | 'gallery' | 'description'>>;

const withDetails = (hotel: HotelSeed, index: number): Hotel => ({
  ...hotel,
  description: hotel.description ?? defaultDescription(hotel.name, hotel.city),
  gallery: hotel.gallery ?? makeGallery(index),
  rooms: hotel.rooms ?? makeRooms(String(hotel.id), hotel.pricePerNight, index),
  reviews: hotel.reviews ?? DEFAULT_REVIEWS,
});

const seeds: HotelSeed[] = [
  {
    id: '1',
    name: 'Шале Роза Хутор',
    city: 'Москва',
    address: 'Москва, ул. Гостиничная, 67',
    rating: 4.9,
    reviewsCount: 142,
    pricePerNight: 5800,
    imageUrl: hotel1Img,
    isPopular: true,
  },
  {
    id: '2',
    name: 'Marine host',
    city: 'Москва',
    address: 'Москва, ул. Университетская, 33',
    rating: 4.9,
    reviewsCount: 142,
    pricePerNight: 7000,
    imageUrl: hotel2Img,
    isPopular: true,
  },
  {
    id: '3',
    name: 'HOTTEL & MARRIAGE GARDEN',
    city: 'Москва',
    address: 'Москва, ул. Садовая, 52',
    rating: 4.9,
    reviewsCount: 142,
    pricePerNight: 3500,
    imageUrl: hotel3Img,
    isPopular: true,
  },
  {
    id: '4',
    name: 'Grand Hotel & Spa',
    city: 'Ялта',
    address: 'Ялта, Набережная им. Ленина, 35',
    rating: 5.0,
    reviewsCount: 210,
    pricePerNight: 9200,
    imageUrl: hotel4Img,
    isPopular: true,
  },
  {
    id: '5',
    name: 'Вилла Елена',
    city: 'Ялта',
    address: 'Ялта, Морская ул., 3',
    rating: 4.8,
    reviewsCount: 98,
    pricePerNight: 8400,
    imageUrl: hotel5Img,
    isPopular: true,
  },
  {
    id: '6',
    name: 'Отель "Аквамарин"',
    city: 'Севастополь',
    address: 'Севастополь, Парковая улица, 11',
    rating: 4.9,
    reviewsCount: 175,
    pricePerNight: 7200,
    imageUrl: hotel6Img,
    isPopular: true,
  },

  // === Севастополь (страница результатов поиска) ===
  {
    id: '7',
    name: "Апартаменты О'Мега",
    city: 'Севастополь',
    address: 'Севастополь, ул. Пляж Омега, 4-5',
    rating: 4.9,
    reviewsCount: 142,
    pricePerNight: 3500,
    imageUrl: hotel4Img,
  },
  {
    id: '8',
    name: 'Парк-отель "Песочная бухта"',
    city: 'Севастополь',
    address: 'Севастополь, улица Ефремова, 38',
    rating: 4.9,
    reviewsCount: 142,
    pricePerNight: 4700,
    imageUrl: hotel12Img,
    description:
      'Курортно-оздоровительный комплекс в Севастополе, расположенный на первой береговой ' +
      'линии в многолетнем дендропарке площадью около 4 гектаров. Он находится в районе ' +
      'Стрелецкой бухты, рядом с заповедником «Херсонес Таврический» и парком имени Анны Ахматовой.',
    gallery: [hotel9Img, hotel7Img, room2Img, hotel11Img],
    rooms: [
      {
        id: '8-r1',
        name: 'Стандартный 2-х местный номер',
        amenities: [...BASE_AMENITIES, 'Балкон'],
        capacity: 2,
        pricePerNight: 5800,
        imageUrl: room2Img,
      },
      {
        id: '8-r2',
        name: 'Семейный люкс',
        amenities: [...BASE_AMENITIES, 'Балкон'],
        capacity: 4,
        pricePerNight: 6300,
        imageUrl: room4Img,
      },
      {
        id: '8-r3',
        name: 'Стандартный 2-х местный номер',
        amenities: [...BASE_AMENITIES, 'Балкон'],
        capacity: 2,
        pricePerNight: 4700,
        imageUrl: room6Img,
      },
    ],
  },
  {
    id: '9',
    name: 'Севастополь Парк',
    city: 'Севастополь',
    address: 'Севастополь, ул. Ленина, 8',
    rating: 4.7,
    reviewsCount: 321,
    pricePerNight: 5200,
    imageUrl: hotel5Img,
  },
  {
    id: '10',
    name: 'Морской бриз',
    city: 'Севастополь',
    address: 'Севастополь, проспект Нахимова, 15',
    rating: 4.6,
    reviewsCount: 87,
    pricePerNight: 3900,
    imageUrl: hotel7Img,
  },
  {
    id: '11',
    name: 'Херсонес Резорт',
    city: 'Севастополь',
    address: 'Севастополь, ул. Древняя, 1',
    rating: 4.9,
    reviewsCount: 203,
    pricePerNight: 8900,
    imageUrl: hotel10Img,
  },
  {
    id: '12',
    name: 'Балаклава Лагуна',
    city: 'Севастополь',
    address: 'Севастополь, Балаклава, наб. Назукина, 12',
    rating: 4.8,
    reviewsCount: 119,
    pricePerNight: 6100,
    imageUrl: hotel11Img,
  },
  {
    id: '13',
    name: 'Вилла Фиолент',
    city: 'Севастополь',
    address: 'Севастополь, Фиолентовское шоссе, 40',
    rating: 4.7,
    reviewsCount: 64,
    pricePerNight: 5600,
    imageUrl: hotel8Img,
  },
  {
    id: '14',
    name: 'Белый берег',
    city: 'Севастополь',
    address: 'Севастополь, ул. Хрусталева, 27',
    rating: 4.5,
    reviewsCount: 52,
    pricePerNight: 4300,
    imageUrl: hotel9Img,
  },
  {
    id: '15',
    name: 'Гранд Отель Крым',
    city: 'Севастополь',
    address: 'Севастополь, Приморский бульвар, 2',
    rating: 5.0,
    reviewsCount: 288,
    pricePerNight: 9800,
    imageUrl: hotel2Img,
  },
  {
    id: '16',
    name: 'Гостевой дом «Ласточка»',
    city: 'Севастополь',
    address: 'Севастополь, ул. Гоголя, 19',
    rating: 4.4,
    reviewsCount: 41,
    pricePerNight: 2900,
    imageUrl: hotel1Img,
  },
  {
    id: '17',
    name: 'Классик Отель',
    city: 'Севастополь',
    address: 'Севастополь, ул. Большая Морская, 31',
    rating: 4.6,
    reviewsCount: 76,
    pricePerNight: 4100,
    imageUrl: hotel3Img,
  },
];

export const hotelsData: Hotel[] = seeds.map(withDetails);

export const popularHotels = hotelsData.filter((h) => h.isPopular);

export const getHotelById = (id?: string): Hotel | undefined =>
  hotelsData.find((h) => String(h.id) === id);

/** Распределение оценок 5..1 (доли), приближённо по среднему рейтингу */
export const getRatingDistribution = (rating: number): number[] => {
  if (rating >= 4.8) return [0.82, 0.12, 0.04, 0.015, 0.005];
  if (rating >= 4.5) return [0.65, 0.22, 0.08, 0.03, 0.02];
  return [0.45, 0.3, 0.15, 0.06, 0.04];
};
