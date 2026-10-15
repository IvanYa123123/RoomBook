// === ИМПОРТ ФОТОГРАФИЙ ОТЕЛЕЙ ===
// Раскомментируйте, когда добавите свои картинки в assets/hotels/:
import hotel1Img from '../assets/hotels/hotel1.jpg';
import hotel2Img from '../assets/hotels/hotel2.jpg';
import hotel3Img from '../assets/hotels/hotel3.jpg';
import hotel4Img from '../assets/hotels/hotel4.jpg';
import hotel5Img from '../assets/hotels/hotel5.jpg';
import hotel6Img from '../assets/hotels/hotel6.jpg';

export interface Hotel {
  id: string | number;
  name: string;
  address: string;
  rating: number;
  reviewsCount: number;
  pricePerNight: number;
  imageUrl: string;
}

export const hotelsData: Hotel[] = [
{
    id: '1',
    name: 'Шале Роза Хутор',
    address: 'Москва, ул. Гостиничная, 67',
    rating: 4.9,
    reviewsCount: 142,
    pricePerNight: 5800,
    imageUrl: hotel1Img,
  },
  {
    id: '2',
    name: 'Marine host',
    address: 'Москва, ул. Университетская, 33',
    rating: 4.9,
    reviewsCount: 142,
    pricePerNight: 7000,
    imageUrl: hotel2Img,
  },
  {
    id: '3',
    name: 'HOTTEL & MARRIAGE GARDEN',
    address: 'Москва, ул. Садовая, 52',
    rating: 4.9,
    reviewsCount: 142,
    pricePerNight: 3500,
    imageUrl: hotel3Img,
  },
  {
    id: '4',
    name: 'Grand Hotel & Spa',
    address: 'Ялта, Набережная им. Ленина, 35',
    rating: 5.0,
    reviewsCount: 210,
    pricePerNight: 9200,
    imageUrl: hotel4Img,
  },
  {
    id: '5',
    name: 'Вилла Елена',
    address: 'Ялта, Морская ул., 3',
    rating: 4.8,
    reviewsCount: 98,
    pricePerNight: 8400,
    imageUrl: hotel5Img,
  },
  {
    id: '6',
    name: 'Аквамарин Резорт',
    address: 'Севастополь, ул. Парковая, 11',
    rating: 4.9,
    reviewsCount: 175,
    pricePerNight: 6300,
    imageUrl: hotel6Img,
  },
];