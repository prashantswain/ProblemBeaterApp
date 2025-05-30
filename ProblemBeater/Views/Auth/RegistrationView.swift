//
//  RegistrationView.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 28/05/25.
//

import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject var navManager: NavigationManager
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var age: String = ""
    @State private var selectedGender: String = ""
    @State private var selectedClass: String = ""
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    
    @ObservedObject var viewModel = SignUpViewModel()
    var body: some View {
        VStack {
            Spacer(minLength: 1)
            ScrollView {
                HStack {
                    VStack(alignment: .leading) {
                        Spacer(minLength: 60)
                        // Profile Image
                        HStack {
                            Spacer()
                            ZStack(alignment: .bottomTrailing) {
                                Group {
                                    if let image = selectedImage{
                                        Image(uiImage: image)
                                            .resizable()
                                    } else {
                                        Image(systemName: "person.circle")
                                            .resizable()
                                    }
                                }
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(.circle)
                                .overlay(Circle().stroke(.appColor3, lineWidth: 2))
                                Button {
                                    // Image Picker
                                    showImagePicker = true
                                } label: {
                                    Image(systemName: "person.crop.square.badge.camera.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(.indigo)
                                        .frame(width: 30, height: 30)
                                }
                            }
                            Spacer()
                        }
                        .padding(.bottom, 30)
                        // Text
                        Text("Let's Sign Up.!")
                            .font(.system(size: 32, design: .rounded))
                            .bold()
                        // TextField
                        VStack(spacing: 16) {
                            TextFieldWithImage(placeHolderText: "Name", text: $name)
                            TextFieldWithImage(placeHolderText: "Email", text: $email, showIcon: true, iconName: "envelope.fill")
                            TextFieldWithImage(placeHolderText: "Mobile Number", text: $email, showIcon: true, iconName: "envelope.fill")
                            CustomSecureTextField(placeHolderText: "Password", text: $password)
                            CustomSecureTextField(placeHolderText: "Confirm Password", text: $confirmPassword)
                            CustomPickerView(placeHolderText: "Gender", dataSources: genders, text: $selectedGender, showIcon: true, iconName: "figure.stand.dress.line.vertical.figure")
                            TextFieldWithImage(placeHolderText: "Age", text: $age)
                            CustomPickerView(placeHolderText: "Class", dataSources: viewModel.classes?.map{$0.name} ?? ["", ""], text: $selectedClass, showIcon: true, iconName: "figure.stand.dress.line.vertical.figure")
                            HStack {
                                Text("Already have an account?")
                                    .font(.system(size: 16, design: .rounded))
                                Button {
                                    // Forgot Password Action
                                    if !navManager.path.isEmpty {
                                        navManager.path.removeLast()
                                    }
                                } label: {
                                    Text("Sign In")
                                        .font(.system(size: 16, design: .rounded))
                                        .padding(.horizontal, -2)
                                }
                                Spacer()
                            }
                            .padding(EdgeInsets(top: -4, leading: 10, bottom: 0, trailing: 0))
                        }
                        AppButton(text: "Sign Up") {
                            Task {
                                await viewModel.fetchData()
                                await navManager.goToLogin()
                            }
                        }
                        .padding(.top, 30)
                    }
                    .padding()
                    Spacer()
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
            .scrollIndicators(.hidden)
        }
        .spinnerOverlay(isLoading: viewModel.isLoading)
        .navigationBarHidden(true)
        .task {
            await viewModel.fetchClasses()
        }
    }
}

#Preview {
    RegistrationView()
}
