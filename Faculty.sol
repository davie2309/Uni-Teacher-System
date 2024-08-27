// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract UniversitySystem is ERC20 {
    struct Teacher {
        address teacherAddress;
        string name;
        uint256 totalClasses;
        uint256 totalLeaves;
        bool exists;
    }
    
    mapping(address => Teacher) public teachers;
    mapping(address => uint256) public attendanceRecord;
    mapping(address => uint256) public leaveRecord;

    // Constructor for ERC20 Token
    constructor() ERC20("ServiceToken", "STK") {}

    // Register a new teacher
    function registerTeacher(address _teacherAddress, string memory _name) public {
        require(!teachers[_teacherAddress].exists, "Teacher already registered");
        teachers[_teacherAddress] = Teacher(_teacherAddress, _name, 0, 0, true);
    }
    
    // Record attendance for a teacher
    function recordAttendance(address _teacherAddress) public {
        require(teachers[_teacherAddress].exists, "Teacher not registered");
        attendanceRecord[_teacherAddress]++;
        teachers[_teacherAddress].totalClasses++;
    }
    
    // Apply for leave
    function applyLeave(address _teacherAddress, uint256 _days) public {
        require(teachers[_teacherAddress].exists, "Teacher not registered");
        leaveRecord[_teacherAddress] += _days;
        teachers[_teacherAddress].totalLeaves += _days;
    }
    
    // Check promotion eligibility
    function checkPromotionEligibility(address _teacherAddress) public view returns (bool) {
        require(teachers[_teacherAddress].exists, "Teacher not registered");
        Teacher memory teacher = teachers[_teacherAddress];
        return (teacher.totalClasses >= 100 && teacher.totalLeaves <= 10);
    }
    
    // Reward a teacher with tokens
    function rewardTeacher(address _teacherAddress, uint256 _amount) public {
        require(teachers[_teacherAddress].exists, "Teacher not registered");
        _mint(_teacherAddress, _amount);
    }
    
    // Get teacher details
    function getTeacherDetails(address _teacherAddress) public view returns (Teacher memory) {
        require(teachers[_teacherAddress].exists, "Teacher not found");
        return teachers[_teacherAddress];
    }
    
    // Get teacher attendance
    function getAttendance(address _teacherAddress) public view returns (uint256) {
        return attendanceRecord[_teacherAddress];
    }
    
    // Get teacher leave record
    function getLeaveRecord(address _teacherAddress) public view returns (uint256) {
        return leaveRecord[_teacherAddress];
    }
}
