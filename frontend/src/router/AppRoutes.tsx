import {Routes, Route, Navigate} from 'react-router-dom';

import Layout from "./../components/layout/Layout"
import LandingPage from '../pages/landing/LandingPage';
import RegistrationPage from '../pages/auth/registration/RegistrationPage';
import LoginPage from '../pages/auth/login/LoginPage';
import SearchPage from '../pages/search/SearchPage';
import HotelPage from '../pages/hotel/HotelPage';

function AppRoutes() {
    return (
        <Routes>
        <Route element={<Layout/>}>
            <Route path='/' element={<LandingPage/>}></Route>
            <Route path='/search' element={<SearchPage/>}></Route>
            <Route path='/hotels/:id' element={<HotelPage/>}></Route>
            <Route path='/reg' element={<RegistrationPage/>}></Route>
            <Route path='/login' element={<LoginPage/>}></Route>
        </Route>
        <Route path='*' element={<Navigate to='/' replace/>}></Route>
        </Routes>
    )
}

export default AppRoutes;
