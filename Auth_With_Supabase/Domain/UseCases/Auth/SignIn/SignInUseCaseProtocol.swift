//
//  SignInUseCaseProtocol.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 21/7/25.
//

protocol SignInUseCaseProtocol {
    func execute(email:String, password:String) async throws -> User 
}
