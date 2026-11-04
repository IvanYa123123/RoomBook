import React from 'react';
import { Link } from 'react-router-dom';
import { useFormik } from 'formik';
import * as Yup from 'yup';

import PasswordField from '../components/PasswordField';
import styles from '../Auth.module.css';

interface RegisterFormValues {
  email: string;
  firstName: string;
  lastName: string;
  password: string;
  accountType: 'renter' | 'landlord';
}

const validationSchema = Yup.object({
  email: Yup.string()
    .email('Введите корректный e-mail')
    .required('Обязательное поле'),
  firstName: Yup.string()
    .trim()
    .required('Обязательное поле'),
  lastName: Yup.string()
    .trim()
    .required('Обязательное поле'),
  password: Yup.string()
    .min(6, 'Пароль должен содержать минимум 6 символов')
    .required('Обязательное поле'),
  accountType: Yup.string()
    .oneOf(['renter', 'landlord'])
    .required('Выберите тип аккаунта'),
});

export const RegistrationPage: React.FC = () => {
  const formik = useFormik<RegisterFormValues>({
    initialValues: {
      email: '',
      firstName: '',
      lastName: '',
      password: '',
      accountType: 'landlord', // по макету выбран "Сдаю жилье"
    },
    validationSchema,
    onSubmit: (values) => {
      console.log('Registration submit:', values);
    },
  });

  return (
    <main className={styles.pageContainer}>
      <div className={styles.card}>
        <h1 className={styles.title}>Регистрация</h1>

        <form onSubmit={formik.handleSubmit} className={styles.form} noValidate>
          {/* E-mail */}
          <div className={styles.formGroup}>
            <label htmlFor="email" className={styles.label}>
              E-mail
            </label>
            <input
              id="email"
              name="email"
              type="email"
              value={formik.values.email}
              onChange={formik.handleChange}
              onBlur={formik.handleBlur}
              className={`${styles.input} ${
                formik.touched.email && formik.errors.email ? styles.inputError : ''
              }`}
              autoComplete="email"
            />
            {formik.touched.email && formik.errors.email && (
              <span className={styles.errorMessage}>{formik.errors.email}</span>
            )}
          </div>

          {/* Имя */}
          <div className={styles.formGroup}>
            <label htmlFor="firstName" className={styles.label}>
              Имя
            </label>
            <input
              id="firstName"
              name="firstName"
              type="text"
              value={formik.values.firstName}
              onChange={formik.handleChange}
              onBlur={formik.handleBlur}
              className={`${styles.input} ${
                formik.touched.firstName && formik.errors.firstName ? styles.inputError : ''
              }`}
              autoComplete="given-name"
            />
            {formik.touched.firstName && formik.errors.firstName && (
              <span className={styles.errorMessage}>{formik.errors.firstName}</span>
            )}
          </div>

          {/* Фамилия */}
          <div className={styles.formGroup}>
            <label htmlFor="lastName" className={styles.label}>
              Фамилия
            </label>
            <input
              id="lastName"
              name="lastName"
              type="text"
              value={formik.values.lastName}
              onChange={formik.handleChange}
              onBlur={formik.handleBlur}
              className={`${styles.input} ${
                formik.touched.lastName && formik.errors.lastName ? styles.inputError : ''
              }`}
              autoComplete="family-name"
            />
            {formik.touched.lastName && formik.errors.lastName && (
              <span className={styles.errorMessage}>{formik.errors.lastName}</span>
            )}
          </div>

          {/* Пароль */}
          <div className={styles.formGroup}>
            <label htmlFor="password" className={styles.label}>
              Пароль
            </label>
            <PasswordField
              id="password"
              name="password"
              value={formik.values.password}
              onChange={formik.handleChange}
              onBlur={formik.handleBlur}
              hasError={Boolean(formik.touched.password && formik.errors.password)}
              autoComplete="new-password"
            />
            {formik.touched.password && formik.errors.password && (
              <span className={styles.errorMessage}>{formik.errors.password}</span>
            )}
          </div>

          {/* Тип аккаунта */}
          <div className={styles.formGroup}>
            <span className={styles.label}>Тип аккаунта</span>
            <div className={styles.radioGroup}>
              <label className={styles.radioLabel}>
                <input
                  type="radio"
                  name="accountType"
                  value="renter"
                  checked={formik.values.accountType === 'renter'}
                  onChange={formik.handleChange}
                  className={styles.radioInput}
                />
                <span>Ищу жилье</span>
              </label>

              <label className={styles.radioLabel}>
                <input
                  type="radio"
                  name="accountType"
                  value="landlord"
                  checked={formik.values.accountType === 'landlord'}
                  onChange={formik.handleChange}
                  className={styles.radioInput}
                />
                <span>Сдаю жилье</span>
              </label>
            </div>
          </div>

          {/* Кнопка регистрации */}
          <button
            type="submit"
            className={styles.submitBtn}
            disabled={formik.isSubmitting}
          >
            Зарегистрироваться
          </button>

          {/* Ссылка на вход */}
          <p className={styles.footerText}>
            Уже есть аккаунт?{' '}
            <Link to="/login" className={styles.link}>
              Войти
            </Link>
          </p>
        </form>
      </div>
    </main>
  );
};

export default RegistrationPage;
