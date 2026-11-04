import React from 'react';
import { Link } from 'react-router-dom';
import { useFormik } from 'formik';
import * as Yup from 'yup';

import PasswordField from '../components/PasswordField';
import styles from '../Auth.module.css';

interface LoginFormValues {
  email: string;
  password: string;
}

const validationSchema = Yup.object({
  email: Yup.string()
    .email('Введите корректный e-mail')
    .required('Обязательное поле'),
  password: Yup.string()
    .required('Обязательное поле'),
});

export const LoginPage: React.FC = () => {
  const formik = useFormik<LoginFormValues>({
    initialValues: {
      email: '',
      password: '',
    },
    validationSchema,
    onSubmit: (values) => {
      console.log('Login submit:', values);
    },
  });

  return (
    <main className={styles.pageContainer}>
      <div className={styles.card}>
        <h1 className={styles.title}>Вход</h1>

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
              autoComplete="current-password"
            />
            {formik.touched.password && formik.errors.password && (
              <span className={styles.errorMessage}>{formik.errors.password}</span>
            )}
          </div>

          {/* Кнопка входа */}
          <button
            type="submit"
            className={styles.submitBtn}
            disabled={formik.isSubmitting}
          >
            Войти
          </button>

          {/* Ссылка на регистрацию */}
          <p className={styles.footerText}>
            Нет аккаунта?{' '}
            <Link to="/reg" className={styles.link}>
              Зарегистрироваться
            </Link>
          </p>
        </form>
      </div>
    </main>
  );
};

export default LoginPage;
