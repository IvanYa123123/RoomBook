import {Routes, Route, Navigate} from 'react-router-dom';

import Layout from "./../components/layout/Layout"
import LandingPage from '../pages/landing/LandingPage';
import RegistrationPage from '../pages/auth/registration/RegistrationPage';

function AppRoutes() {
    return (
        <Routes>
        <Route element={<Layout/>}>
            <Route path='/' element={<LandingPage/>}></Route>
            <Route path='/reg' element={<RegistrationPage/>}></Route>
            
        </Route>
        <Route path='*' element={<Navigate to='/' replace/>}></Route>
        </Routes>
    )
}

export default AppRoutes;